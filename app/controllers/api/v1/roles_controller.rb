class Api::V1::RolesController < AuthenticatedController
  before_action :check_permission

  def check_permission
    action = nil
    if ["index", "show" ].include?(params[:action]) 
      action = "read"
    elsif ["create", "update"].include?(params[:action]) 
      action = "write"
    elsif ["destroy", "remove_role"].include?(params[:action]) 
      action = "delete"
    end
    
    program_id = params[:project_id] ? params[:project_id] : params[:role][:project_id]

    raise(CanCan::AccessDenied) if !current_user.has_program_setting_role?(program_id)
  end

  def index
    project = Project.find(params[:project_id])
    roles = project.roles.includes([:role_privileges, {role_users: :user}]).map(&:to_json)
    roles += Role.includes([:role_privileges, {role_users: :user}]).default_roles.map(&:to_json)
    render json: {roles: roles}
  end

  def create
    role = Role.new.create_or_update_role(roles_params, current_user)
    if role.persisted?
      render json: {message: "Role created successfully", role: role.to_json}
    else
      render json: {errors: role.errors.full_messages}, status: 422
    end
  end

  def add_users
    role = Role.find(params[:id])
    role_users = role_users_params["role_users"]
    role_users.each do |role_user_hash|
      role.role_users.create(role_user_hash)
    end
  end

  def remove_role
    project = Project.find(params[:project_id])

    if params[:role_from_users]
      role = Role.find(params[:role_id])
      user_ids = User.where(id: params[:user_ids]).pluck(:id)
      RoleUser.where(role_id: role.id, user_id: user_ids, project_id: project.id).destroy_all
    elsif params[:user_from_roles]
      user = User.find(params[:user_id])
      role_ids = Role.where(id: params[:role_ids]).pluck(:id)
      RoleUser.where(role_id: role_ids, user_id: user.id, project_id: project.id).destroy_all
    elsif params[:role_from_projects]
      role = Role.find(params[:role_id])
      facility_project_ids = FacilityProject.where(id: params[:facility_project_ids]).pluck(:id)
      RoleUser.where(role_id: role.id, facility_project_id: facility_project_ids).destroy_all
    elsif params[:role_from_contractss]
      role = Role.find(params[:role_id])
      contract_ids = Contract.where(id: params[:contract_ids]).pluck(:id)
      RoleUser.where(role_id: role.id, contract_id: contract_ids).destroy_all
    elsif params[:project_from_roles]
      role_ids = Role.find(params[:role_ids])
      facility_project_id = FacilityProject.where(id: params[:facility_project_id]).pluck(:id)
      RoleUser.where(role_id: role_ids, facility_project_id: facility_project_id).destroy_all
    elsif params[:contract_from_roles]
      role_ids = Role.find(params[:role_ids])
      contract_id = Contract.where(id: params[:contract_id]).pluck(:id)
      RoleUser.where(role_id: role_ids, contract_id: contract_id).destroy_all
    end

  end



  def update
    role = Role.new.create_or_update_role(roles_params, current_user)
    if role.persisted?
      render json: {message: "Role created successfully", role: role.to_json}
    else
      render json: {errors: role.errors.full_messages}, status: 422
    end
  end

  def destroy
    role = Role.find_by(id: params[:id], project_id: params[:program_id] )
    if !role
      raise ActiveRecord::RecordNotFound, "Role Not found"
    elsif role.validate && role.destroy
      render json: {message: "Role deleted successfully!!", role: role.to_json}
    else
      render json: {errors: role.errors.full_messages}, status: 422
    end
  end

  private
  def role_users_params
    params.permit(role_users: [:role_id, :user_id, :project_id, :contract_id, :facility_id, :facility_project_id])
  end
  def roles_params
    params.require(:role).permit(:id, :name, :project_id, :type_of, role_privileges: [:id, :privilege, :role_type, :name])
  end
end
