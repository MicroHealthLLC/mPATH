class Api::V1::Portfolio::ContractProjectDataController < AuthenticatedController
  before_action :check_contract_read_permission, only: [:index]
  before_action :check_contract_write_permission, only: [:create, :update]
  before_action :check_contract_delete_permission, only: [:destroy]
  
  def check_contract_read_permission

    program_id = params[:project_id]

    action = nil

    if ["index", "show" ].include?(params[:action]) 
      action = "R"
    elsif ["create", "update"].include?(params[:action]) 
      action = "W"
    elsif ["destroy"].include?(params[:action]) 
      action = "D"
    end

    raise(CanCan::AccessDenied) if !current_user.has_program_setting_role?(program_id, action, RolePrivilege::PROGRAM_SETTING_CONTRACTS) && !current_user.can_read_contract_data?

  end

  def check_contract_write_permission
    raise(CanCan::AccessDenied) if !current_user.can_write_contract_data?
  end
  
  def check_contract_delete_permission
    raise CanCan::AccessDenied if !current_user.can_delete_contract_data?
  end

  def index
    authorized_contract_ids = current_user.authorized_contract_ids
    project_ids = ProjectContract.where(id: authorized_contract_ids).pluck(:project_id).uniq

    role_users = current_user.role_users.joins(:role_privileges).where("role_privileges.privilege REGEXP '^[RWD]' and role_privileges.role_type = 'contract_tasks' and role_users.project_contract_id in (?)", authorized_contract_ids).group_by{|rs| rs.project_contract_id }


    contract_project_data = ContractProjectDatum.includes([:projects, :project_contracts, {contract_vehicle: [:contract_vehicle_type, :contract_sub_category, {contract_project_poc_resources: :contract_project_poc}] }, :contract_award_to, :contract_naic, :contract_customer, :contract_award_type, :contract_type, :contract_current_pop, :contract_pop, :contract_number, :user, {contract_project_poc_resources: :contract_project_poc}]).all.map{|c| c.to_json({authorized_project_ids: project_ids, role_users: role_users}) }
    render json: {contract_project_data: contract_project_data}
  end

  def create
    contract_project_data = ContractProjectDatum.new.create_or_update_contract_project_data(params, current_user)
    if !contract_project_data.errors.any?
      render json: {contract_project_data: contract_project_data.to_json}
    else
      render json: {errors: contract_project_data.errors.full_messages}, status: 406
    end
  end

  def update
    contract_project_data = ContractProjectDatum.new.create_or_update_contract_project_data(params, current_user)
    if !contract_project_data.errors.any?
        render json: {contract_project_data: contract_project_data.to_json}
    else
      render json: {errors: contract_project_data.errors.full_messages}, status: 406
    end
  end

  def destroy
    contract_project_data = ContractProjectDatum.find(params[:id])
    if contract_project_data.destroy
        render json: {contract_project_data: contract_project_data, message: "Contract Project Data deleted successfully!!"}
    else
      render json: {errors: contract_project_data.errors.full_messages}, status: 406
    end
  end
end