class Api::V1::ProgramSettings::RolesController < AuthenticatedController
  before_action :check_program_admin

  def check_permission
    raise(CanCan::AccessDenied) if !params[:project_id]
    action = nil
    if ["index", "show" ].include?(params[:action]) 
      action = "read"
    elsif ["create", "update"].include?(params[:action]) 
      action = "write"
    elsif ["destroy", "remove_role"].include?(params[:action]) 
      action = "delete"
    end
    
    program_id = params[:project_id]

    raise(CanCan::AccessDenied) if !current_user.has_program_setting_role?(program_id)
  end

  def index
    project = Project.find(params[:project_id])
    project_user_ids = project.user_ids

    if params[:page] == "user_tab_role_assign"
      roles = project.roles.distinct.includes([:role_privileges, {role_users: [:user, :role, {facility_project: :facility}, :contract ] }]).map{|r| r.to_json( params.merge({include: [:all]}) )}

      default_roles = Role.includes([:role_privileges, {role_users: [:user, :role] }]).default_roles.where("role_users.user_id" => project_user_ids, "role_users.project_id" => project.id)

      default_role_ids = default_roles.pluck(:id)

      roles += default_roless.map{|r| r.to_json({include: [:all]}) }

      roles += Role.includes([:role_privileges, {role_users: [:user, :role] }]).default_roles.where.not(id: default_role_ids).map{|r| r.to_json(params.merge({include: [:all]}) ) }
      
      roles += Role.includes([:role_privileges, {role_users: [:user, :role, {facility_project: :facility}, :contract] }]).default_roles.where("role_users.user_id" => project_user_ids, "role_users.project_id" => project.id).map{|r| r.to_json( params.merge({include: [:all]}) ) }
      
    else
      roles = project.roles.includes([:role_privileges, {role_users: [:user, :role] }]).map{|r| r.to_json({include: [:all]}) }
      
      default_roles = Role.includes([:role_privileges, {role_users: [:user, :role] }]).default_roles.where("role_users.user_id" => project_user_ids, "role_users.project_id" => project.id)

      default_role_ids = default_roles.pluck(:id)
      
      roles += default_roles.map{|r| r.to_json({include: [:all]}) }

      roles += Role.includes([:role_privileges, {role_users: [:user, :role] }]).default_roles.where.not(id: default_role_ids).map{|r| r.to_json({include: [:role_privileges]}) }

    end

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
    errors = []
    role_users.each do |role_user_hash|
      role_user  = role.role_users.new(role_user_hash)
      if !role_user.check_only_single_admin_role
        if !role_user.save
          errors += role_user.errors.full_messages
        end
      end
    end
    if !errors.any?
      render json: {message: "User added to role successfully!!", role: role.to_json}
    else
      render json: {errors: errors.compact.uniq}, status: 422
    end
  end

  def remove_role
    project = Project.find(params[:project_id])

    if params[:role_from_users]
      role = Role.find(params[:role_id])
      user_ids = User.where(id: params[:user_id]).pluck(:id)
      RoleUser.where(role_id: role.id, user_id: user_ids, project_id: project.id).destroy_all
    elsif params[:user_from_roles]
      user = User.find(params[:user_id])
      role_ids = Role.where(id: params[:role_id]).pluck(:id)
      RoleUser.where(role_id: role_ids, user_id: user.id, project_id: project.id).destroy_all
    elsif params[:role_from_projects]
      role = Role.find(params[:role_id])
      facility_project_ids = FacilityProject.where(id: params[:facility_project_id]).pluck(:id)
      RoleUser.where(role_id: role.id, facility_project_id: facility_project_ids).destroy_all
    elsif params[:role_from_contracts]
      role = Role.find(params[:role_id])
      contract_ids = Contract.where(id: params[:contract_id]).pluck(:id)
      RoleUser.where(role_id: role.id, contract_id: contract_ids).destroy_all
    elsif params[:project_from_roles]
      role_ids = Role.where(id: params[:role_id]).pluck(:id)
      facility_project_id = FacilityProject.where(id: params[:facility_project_id]).pluck(:id)
      RoleUser.where(role_id: role_ids, facility_project_id: facility_project_id).destroy_all
    elsif params[:contract_from_roles]
      role_ids = Role.where(id: params[:role_id]).pluck(:id)
      contract_id = Contract.where(id: params[:contract_id]).pluck(:id)
      RoleUser.where(role_id: role_ids, contract_id: contract_id).destroy_all
    elsif params[:users_from_project_role]
      role_ids = Role.where(id: params[:role_id]).pluck(:id)
      user_ids = User.where(id: params[:user_id]).pluck(:id)
      facility_project_id = FacilityProject.where(id: params[:facility_project_id]).pluck(:id)
      RoleUser.where(role_id: role_ids, facility_project_id: facility_project_id, user_id: user_ids).destroy_all
    elsif params[:users_from_contract_role]
      role_ids = Role.where(id: params[:role_id]).pluck(:id)
      user_ids = User.where(id: params[:user_id]).pluck(:id)
      contract_id = Contract.where(id: params[:contract_id]).pluck(:id)
      RoleUser.where(role_id: role_ids, contract_id: contract_id, user_id: user_ids).destroy_all
    end
    render json: {message: "Successfully removed role!!"}
  end

  def update
    role = Role.new.create_or_update_role(roles_params, current_user)
    if role.persisted?
      render json: {message: "Role updated successfully", role: role.to_json}
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
