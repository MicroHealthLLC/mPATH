class Api::V1::ProgramSettings::RolesController < AuthenticatedController
  before_action :check_permission

  def check_permission
    program_id = params[:project_id]

    raise(CanCan::AccessDenied) if !program_id
    action = nil
    if ["index", "show" ].include?(params[:action]) 
      action = "R"
    elsif ["create", "update", "add_users"].include?(params[:action]) 
      action = "W"
    elsif ["destroy", "remove_role"].include?(params[:action]) 
      action = "D"
    end

    raise(CanCan::AccessDenied) if !current_user.has_program_setting_role?(program_id,action,  RolePrivilege::PROGRAM_SETTING_USERS_ROLES)
  end

  def index
    project = Project.find(params[:project_id])
    project_user_ids = project.user_ids

    if params[:page] == "user_tab_role_assign"
      roles = project.roles.distinct.includes([:role_privileges, {role_users: [:user, :role, {facility_project: :facility}, :project_contract ] }]).map{|r| r.to_json( params.merge({include: [:all]}) )}

      default_roles = Role.includes([:role_privileges, {role_users: [:user, :role] }]).default_roles.where("role_users.user_id" => project_user_ids, "role_users.project_id" => project.id)

      default_role_ids = default_roles.pluck(:id)

      roles += default_roles.map{|r| r.to_json({include: [:all]}) }

      roles += Role.includes([:role_privileges, {role_users: [:user, :role] }]).default_roles.where.not(id: default_role_ids).map{|r| r.to_json(params.merge({include: [:all]}) ) }
      
      roles += Role.includes([:role_privileges, {role_users: [:user, :role, {facility_project: :facility}, :project_contract] }]).default_roles.where("role_users.user_id" => project_user_ids, "role_users.project_id" => project.id).map{|r| r.to_json( params.merge({include: [:all]}) ) }
      
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
    role = Role.includes([:role_privileges, {role_users: [:user, :role, {facility_project: :facility}, :project_contract] }]).find(params[:id])
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
      render json: {message: "User added to role successfully!!", role: role.to_json({page: 'user_tab_role_assign', include: [:all] })}
    else
      render json: {errors: errors.compact.uniq}, status: 422
    end
  end

  def remove_role
    project = Project.includes(:users, :role_users).find(params[:project_id])
    role_ids = Role.where(id: params[:role_id]).pluck(:id)
    
    conditions = {
      project_id: project.id,
      role_id: role_ids
    }

    if params[:user_id]
      conditions[:user_id] = params[:user_id]
    end

    if params[:facility_project_id]
      conditions[:facility_project_id] = params[:facility_project_id]
    end

    if params[:project_contract_id]
      conditions[:project_contract_id] = params[:project_contract_id]
    end

    if !conditions[:role_id] || !conditions[:role_id].any?
      render json: {message: "Invalid parameter: Role must be provided."}, status: 406
    else
      role_users = RoleUser.where(conditions)
      program_admin_role = Role.program_admin_user_role
      program_admin_user_ids = project.get_program_admin_ids
      errors = []
      role_users.each do |role_user|
        if program_admin_role.id == role_user.role_id && program_admin_user_ids.size < 2
          errors << "Program must have at least one program admin user."
        else
          if !role_user.destroy
            errors += role_user.errors.full_messages
          end
        end
      end
      if errors.size > 0
        render json: {errors: errors.join(", ")}, status: 406
      else
        render json: {message: "Successfully removed role!!"}, status: 200
      end
    end
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
    params.permit(role_users: [:role_id, :user_id, :project_id, :project_contract_id, :facility_id, :facility_project_id])
  end
  def roles_params
    params.require(:role).permit(:id, :name, :project_id, :type_of, role_privileges: [:id, :privilege, :role_type, :name])
  end
end
