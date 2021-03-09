class IssuesController < AuthenticatedController
  before_action :set_resources
  before_action :set_issue, only: [:show, :update, :destroy, :create_duplicate, :create_bulk_duplicate]

  def index

    all_users = []
    all_user_ids = []

    all_issues = Issue.unscoped.includes([{issue_files_attachments: :blob}, :issue_type, :issue_users, {users: :organization}, :issue_stage, {checklists: [:user, {progress_lists: :user} ] },  { notes: :user }, :related_tasks, :related_issues,:related_risks, :sub_tasks, :sub_issues, :sub_risks, {facility_project: :facility}, :issue_severity ]).where(facility_project_id: @facility_project.id)
    all_issue_users = IssueUser.where(issue_id: all_issues.map(&:id) ).group_by(&:issue_id)
    all_user_ids += all_issue_users.values.flatten.map(&:user_id)
    all_user_ids = all_user_ids.compact.uniq

    all_users = User.includes(:organization).where(id: all_user_ids ).active
    all_organizations = Organization.where(id: all_users.map(&:organization_id).compact.uniq )

    issues = all_issues.compact.uniq

    h = []
    issues.each do |i| 
      h << i.to_json( {orgaizations: all_organizations, all_issue_users: all_issue_users[i.id], all_users: all_users,for: :issue_index} )
    end

    render json: h

    # render json: {issues: @facility_project.issues.map(&:to_json)}
  end

  def create
    @issue = Issue.new.create_or_update_issue(params, current_user)
    render json: {issue: @issue.reload.to_json}
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
    @issue.update(i_params)
    @issue.assign_users(params)

    render json: {issue: @issue.reload.to_json}
  end

  def create_duplicate
    duplicate_issue = @issue.amoeba_dup
    duplicate_issue.save
    # @task.create_or_update_task(params, current_user)
    render json: {issue: duplicate_issue.reload.to_json}
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
    # duplicate_task.save
    # @task.create_or_update_task(params, current_user)
    render json: {issues: all_objs.map(&:to_json)}
  end

  def show
    render json: {issue: @issue.to_json}
  end

  def destroy
    @issue.destroy!
    render json: {}, status: 200
  rescue
    render json: {}, status: 500
  end

  def batch_update
    Issue.update(params[:issues].keys, params[:issues].values)
    render json: @facility_project.as_json
  end

  private
  def set_resources
    @project = current_user.projects.active.find_by(id: params[:project_id])
    @facility_project = @project.facility_projects.find_by(facility_id: params[:facility_id])
  end

  def set_issue
    @issue = @facility_project.issues.find_by(id: params[:id])
  end

  def issue_params
    params.require(:issue).permit(
      :title,
      :description,
      :issue_type_id,
      :issue_stage_id,
      :issue_severity_id,
      :facility_project_id,
      :progress,
      :start_date,
      :due_date,
      :auto_calculate,
      :watched,
      :task_type_id,
      :kanban_order,
      issue_files: [],
      user_ids: [],
      sub_task_ids: [],
      sub_issue_ids: [],
      sub_risk_ids: [],
      checklists_attributes: [
        :id,
        :_destroy,
        :text,
        :user_id,
        :checked,
        :position,
        :due_date,
        :position,
         progress_lists_attributes: [
          :id,
          :_destroy,
          :body,
          :checklist_id,
          :user_id
        ]
      ],
      notes_attributes: [
        :id,
        :_destroy,
        :user_id,
        :body
      ]
    )
  end

  def destroy_file_ids
    params[:issue][:destroy_file_ids]&.split(',')&.map(&:to_i)
  end

  def destroy_files_first
    @issue.issue_files.where(id: destroy_file_ids)&.map(&:purge)
  end
end
