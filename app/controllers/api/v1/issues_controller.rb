class Api::V1::IssuesController < AuthenticatedController 
# NOTE: uncomment this when we move to token based authentication
# class Api::V1::IssuesController < Api::ApplicationController
  before_action :set_resources#, except: [:show]
  before_action :set_issue, only: [:update, :destroy, :create_duplicate, :create_bulk_duplicate]
  before_action :check_permission  

  def check_permission
    action = nil
    if ["index", "show" ].include?(params[:action]) 
      action = "read"
    elsif ["create", "update", "create_duplicate", "create_bulk_duplicate", "batch_update"].include?(params[:action]) 
      action = "write"
    elsif ["destroy"].include?(params[:action]) 
      action = "delete"
    end

    if params[:project_contract_id]
      raise(CanCan::AccessDenied) if !current_user.has_contract_permission?(action: action,resource: 'issues', project_contract: params[:project_contract_id])
    elsif params[:project_contract_vehicle_id]
      raise(CanCan::AccessDenied) if !current_user.has_contract_permission?(action: action,resource: 'issues', project_contract_vehicle: params[:project_contract_vehicle_id])
    else
      raise(CanCan::AccessDenied) if !current_user.has_permission?(action: action,resource: 'issues', program: params[:project_id], project: params[:facility_id])
    end

  end
  def index

    all_users = []
    all_user_ids = []

    all_issues = Issue.unscoped.includes([{issue_files_attachments: :blob}, :issue_type, :task_type, { issue_users: :user} , {users: :organization}, :issue_stage, {checklists: [:user, {progress_lists: :user} ] },  { notes: :user }, :related_tasks, :related_issues,:related_risks, :sub_tasks, :sub_issues, :sub_risks, {facility_project: :facility}, :issue_severity ]).where("issues.facility_project_id in (?) or issues.project_contract_id in (?)  or issues.project_contract_vehicle_id in (?)", [@owner.id], [@owner.id], [@owner.id]).paginate(:page => params[:page], :per_page => 15)

    all_issue_users = IssueUser.where(issue_id: all_issues.map(&:id) ).group_by(&:issue_id)
    all_user_ids += all_issue_users.values.flatten.map(&:user_id)
    all_user_ids = all_user_ids.compact.uniq

    all_users = User.includes(:organization).where(id: all_user_ids ).active
    all_organizations = Organization.where(id: all_users.map(&:organization_id).compact.uniq )

    h = []
    all_issues.each do |i| 
      h << i.to_json( {orgaizations: all_organizations, all_issue_users: all_issue_users[i.id], all_users: all_users,for: :issue_index} )
    end

    render json: {issues: h, total_pages: all_issues.total_pages, current_page: all_issues.current_page, next_page: all_issues.next_page}

    # render json: {issues: @facility_project.issues.map(&:to_json)}
  end

  def create
    @issue = Issue.new.create_or_update_issue(params, current_user)
    if @issue.errors.any?
      render json: {errors:@issue.reload.to_json, msg: @issue.errors.full_messages.join(" ")}, status: 406
    else
      render json: {issue: @issue.reload.to_json, msg: 'Issue created successfully.'}, status: 200
    end
  end

  def update
    destroy_files_first if destroy_file_ids.present?
    i_params = issue_params.dup
    if i_params[:checklists_attributes].present?
      i_params[:checklists_attributes].each do |key, hash|
        if hash["progress_lists_attributes"].present?
          hash["progress_lists_attributes"].each do |key2, hash2|
            hash2[:user_id] = current_user.id if hash2[:user_id].nil?
          end
        end
      end
    end
    if @issue.update(i_params)
      @issue.assign_users(params)
      @issue.add_link_attachment(params)
      if params[:source] == "portfolio_viewer"
        render json: {issue: @issue.reload.portfolio_json, msg: 'Issue updated successfully.'}
      else
        render json: {issue:  @issue.reload.to_json, msg: 'Issue updated successfully.'}
      end 
    else
      render json: {issue:  @issue.reload.to_json, msg: @issue.errors.full_messages.join(" ,")}, status: :unprocessable_entity
    end
  
  end

  def create_duplicate
    duplicate_issue = @issue.amoeba_dup
    duplicate_issue.save
    # @task.create_or_update_task(params, current_user)
    render json: {issue: duplicate_issue.reload.to_json, msg: 'Duplicate issue created successfully.'}
  end

  def create_bulk_duplicate
    all_objs = []
    if params[:facility_project_ids].present?
      params[:facility_project_ids].each do |fp_id|
        duplicate_issue = @issue.amoeba_dup
        duplicate_issue.facility_project_id = fp_id
        duplicate_issue.save
        all_objs << duplicate_issue
      end
    end
    if params[:project_contract_ids].present?
      params[:project_contract_ids].each do |c_id|
        duplicate_issue = @issue.amoeba_dup
        duplicate_issue.project_contract_id = c_id
        duplicate_issue.save
        all_objs << duplicate_issue
      end
    end
    if params[:project_contract_vehicle_ids].present?
      params[:project_contract_vehicle_ids].each do |c_id|
        duplicate_issue = @issue.amoeba_dup
        duplicate_issue.project_contract_vehicle_id = c_id
        duplicate_issue.save
        all_objs << duplicate_issue
      end
    end
    # duplicate_task.save
    # @task.create_or_update_task(params, current_user)
    render json: {issues: all_objs.map(&:to_json), msg: 'Bulk Duplicate issues created successfully.'}
  end

  def show
    @issue = @owner.issues.includes([{issue_files_attachments: :blob}, :issue_type, :task_type, :issue_users, {users: :organization}, :issue_stage, {checklists: [:user, {progress_lists: :user} ] },  { notes: :user }, :related_tasks, :related_issues,:related_risks, :sub_tasks, :sub_issues, :sub_risks, {facility_project: :facility}, :issue_severity ]).find(params[:id])
    render json: {issue: @issue.to_json}
  end

  def destroy
    if @issue.destroy!
      render json: {msg: "Issue destroyed successfully"}, status: 200
    else
      render json: {msg: "Error in issue destroy"}, status: :unprocessable_entity
    end
  end

  def batch_update
    if Issue.update(params[:issues].keys, params[:issues].values)
      render json: {msg: "Issue destroyed successfully"}, status: 200

    else
      render json: {msg: "Error updating batch issues!"}, status: :unprocessable_entity
    end
    render json: @facility_project.as_json
  end

  private
  def set_resources
    @owner = nil
    if params[:project_contract_id]
      @owner = current_user.authorized_contracts.find_by(id: params[:project_contract_id] )
    elsif params[:project_contract_vehicle_id]
      @owner = ProjectContractVehicle.find_by(id: params[:project_contract_vehicle_id] )
    else
      @project = current_user.authorized_programs.find_by(id: params[:project_id])
      @owner = @project.facility_projects.find_by(facility_id: params[:facility_id])
    end
  end

  def set_issue
    @issue = @owner.issues.find(params[:id])
  end

  def issue_params
    params.require(:issue).permit(Issue.params_to_permit)
  end

  def destroy_file_ids
    params[:issue][:destroy_file_ids]&.split(',')&.map(&:to_i)
  end

  def destroy_files_first
    @issue.issue_files.where(id: destroy_file_ids)&.map(&:purge)
  end
end
