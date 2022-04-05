class Api::V1::RolesController < AuthenticatedController
  def index
    project = Project.find(params[:project_id])
    roles = project.roles.includes([:role_privileges, {role_users: :user}]).map(&:to_json)
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

  def update

  end

  def destroy
    
  end

  private
  def role_users_params
    params.permit(role_users: [:role_id, :user_id, :project_id, :contract_id, :facility_id, :facility_project_id])
  end
  def roles_params
    params.require(:role).permit(:id, :name, :project_id, :type_of, role_privileges: [:id, :privilege, :role_type, :name])
  end
end
