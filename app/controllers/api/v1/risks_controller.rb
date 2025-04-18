class Api::V1::RisksController < AuthenticatedController 
# NOTE: uncomment this when we move to token based authentication
# class  Api::V1::RisksController < Api::ApplicationController
  before_action :set_resources#, except: [:show]
  before_action :set_risk, only: [:update, :destroy, :create_duplicate, :create_bulk_duplicate]
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
      raise(CanCan::AccessDenied) if !current_user.has_contract_permission?(action: action,resource: 'risks', project_contract: params[:project_contract_id])
    elsif params[:project_contract_vehicle_id]
      raise(CanCan::AccessDenied) if !current_user.has_contract_permission?(action: action,resource: 'risks', project_contract_vehicle: params[:project_contract_vehicle_id])
    else
      raise(CanCan::AccessDenied) if !current_user.has_permission?(action: action,resource: 'risks', program: params[:project_id], project: params[:facility_id])
    end

  end
  def index

    all_users = []
    all_user_ids = []
    
    all_risks = Risk.unscoped.includes([{risk_files_attachments: :blob}, :task_type, :risk_users, {user: :organization},:risk_stage, {checklists: [:user, {progress_lists: :user} ] },  { notes: :user }, :related_tasks, :related_issues,:related_risks, :sub_tasks, :sub_issues, :sub_risks, {facility_project: :facility} ]).where("risks.facility_project_id in (?) or risks.project_contract_id in (?)  or risks.project_contract_vehicle_id in (?)", [@owner.id], [@owner.id], [@owner.id]).paginate(:page => params[:page], :per_page => 15)

    all_risk_users = RiskUser.where(risk_id: all_risks.map(&:id) ).group_by(&:risk_id)
    all_user_ids += all_risk_users.values.flatten.map(&:user_id)
    all_user_ids = all_user_ids.compact.uniq

    all_users = User.includes(:organization).where(id: all_user_ids ).active
    all_organizations = Organization.where(id: all_users.map(&:organization_id).compact.uniq )

    h = []
    all_risks.each do |r|
      h << r.to_json( {orgaizations: all_organizations, all_risk_users: all_risk_users[r.id], all_users: all_users, for: :risk_index} )
    end

    render json: {risks: h, total_pages: all_risks.total_pages, current_page: all_risks.current_page, next_page: all_risks.next_page}

    # render json: {risks: @facility_project.risks.map(&:to_json)}
  end

  def create
    # @risk = Risk.create(risk_params.merge(user_id: current_user.id))
    # @risk.assign_users(params)
    
    @risk = Risk.new.create_or_update_risk(params, current_user)
    if @risk.errors.any?
      render json: {task: @risk.to_json, msg:  @risk.errors.full_messages.join(", "), errors: @risk.errors.full_messages.join(", ") }, status: :unprocessable_entity
    else
      render json: {risk: @risk.reload.to_json, msg: 'Risk created successfully!'}
    end
  end

  def update
    destroy_files_first if destroy_file_ids.present?
    r_params = risk_params.dup
    if r_params[:checklists_attributes].present?
      r_params[:checklists_attributes].each do |key, hash|
        if hash["progress_lists_attributes"].present?
          hash["progress_lists_attributes"].each do |key2, hash2|
            hash2[:user_id] = current_user.id if hash2[:user_id].nil?
          end
        end
      end
    end
    @risk.update(r_params)
    @risk.assign_users(params)
    @risk.add_link_attachment(params)
    if params[:source] == "portfolio_viewer"
      response = @risk.reload.portfolio_json
    else
      response = @risk.reload.to_json
    end
    if @risk.errors.any?
      render json: {task: @risk.to_json, msg: @risk.errors.full_messages.join(", "), errors: @risk.errors.full_messages.join(", ") }, status: :unprocessable_entity
    else
      render json: {risk: response, msg: "Risk updated successfully"}
    end

  end

  def create_duplicate
    duplicate_risk = @risk.amoeba_dup
    duplicate_risk.save
    # @task.create_or_update_task(params, current_user)
    render json: {risk: duplicate_risk.reload.to_json, msg: "Duplicate risk created successfully"}
  end

  def create_bulk_duplicate
    all_objs = []
    if params[:facility_project_ids].present?
      params[:facility_project_ids].each do |fp_id|
        duplicate_risk = @risk.amoeba_dup
        duplicate_risk.facility_project_id = fp_id
        duplicate_risk.save
        all_objs << duplicate_risk
      end
    end
    if params[:project_contract_ids].present?
      params[:project_contract_ids].each do |c_id|
        duplicate_risk = @risk.amoeba_dup
        duplicate_risk.project_contract_id = c_id
        duplicate_risk.save
        all_objs << duplicate_risk
      end
    end
    if params[:project_contract_vehicle_ids].present?
      params[:project_contract_vehicle_ids].each do |c_id|
        duplicate_risk = @risk.amoeba_dup
        duplicate_risk.project_contract_vehicle_id = c_id
        duplicate_risk.save
        all_objs << duplicate_risk
      end
    end
    # duplicate_task.save
    # @task.create_or_update_task(params, current_user)
    render json: {risks: all_objs.map(&:to_json), msg: "Bulk duplicate risk created successfully"}
  end

  def show
    @risk = @owner.risks.includes([{risk_files_attachments: :blob}, :task_type, :risk_users, {user: :organization},:risk_stage, {checklists: [:user, {progress_lists: :user} ] },  { notes: :user }, :related_tasks, :related_issues,:related_risks, :sub_tasks, :sub_issues, :sub_risks, {facility_project: :facility} ]).find(params[:id])
    render json: {risk: @risk.to_json}
  end

  def destroy
    if @risk.destroy!
      render json: {msg: "Risk destroyed successfully"}, status: 200
    else
      render json: {msg: "Error in risk destroy"}, status: :unprocessable_entity
    end
  end

  def batch_update
    if Risk.update(params[:risks].keys, params[:risks].values)
      render json: {facility_project: @facility_project.as_json, msg: "Risk batch update successfully"}
    else
      render json: {msg: "Error risk batch update"}, status: :unprocessable_entity
    end
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
  

  def set_risk
    @risk = @owner.risks.find_by(id: params[:id])
  end

  def risk_params
    params.require(:risk).permit(Risk.params_to_permit)
  end

  def destroy_file_ids
    params[:risk][:destroy_file_ids]&.split(',')&.map(&:to_i)
  end

  def destroy_files_first
    @risk.risk_files.where(id: destroy_file_ids)&.map(&:purge)
  end
end
