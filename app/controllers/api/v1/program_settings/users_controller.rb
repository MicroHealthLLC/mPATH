class Api::V1::ProgramSettings::UsersController < AuthenticatedController
  before_action :check_permission, except: [:get_user_privileges]

  def check_permission
    program_id = params[:program_id]

    raise(CanCan::AccessDenied) if !program_id
    action = nil
    if ["index", "show", "get_user_privileges" ].include?(params[:action]) 
      action = "R"
    elsif ["create", "update", "add_to_program","remove_from_program"].include?(params[:action]) 
      action = "W"
    elsif ["destroy", "remove_role"].include?(params[:action]) 
      action = "D"
    end

    raise(CanCan::AccessDenied) if !current_user.has_program_setting_role?(program_id, action,  RolePrivilege::PROGRAM_SETTING_USERS_ROLES)
  end

  def get_user_privileges

    project = Project.find_by(id: params[:program_id])
    response_hash = {}

    if !project
      render json: {message: "No program found!!"}, status: 404
    else
      response_hash = {
        program_admin_role: Role.program_admin_user_role.to_json,
        program_privileges_roles: current_user.project_privileges_hash_by_role(program_ids: [project.id]),
        contract_privileges_roles: current_user.privileges_hash_by_role(program_ids: [project.id], resource_type: 'contract'),
        contract_vehicle_privileges_roles: current_user.privileges_hash_by_role(program_ids: [project.id], resource_type: 'contract_vehicle'),
        project_privileges_roles: current_user.privileges_hash_by_role(program_ids: [project.id], resource_type: 'facility_project'),
        program_settings_privileges_roles: current_user.program_settings_privileges_hash_by_role(program_ids: [project.id])
      }
      render json: response_hash, status: 200
    end

  end

  def index
    @users = []    
    status_code = 200
    if params[:all].present?
      @users = User.active.map(&:as_json)
    elsif params[:program_id].present?
      @users = Project.where(id: params[:program_id]).first.users.includes(:organization).as_json
    else
      status_code = 406
    end
    render json: @users, status: status_code
  end

  def create
    @user = User.new(user_params)
    @user.password = "changeme"
    if @user.save      
      render json: {msg: @user.id }, status: 200
    else
      render json: {msg: "Error crating user"}, status: 406
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      render json: {msg: "User updated successfully!"}, status: 200
    else
      render json: {msg: @user.errors.full_messages.join(",")}, status: 406
    end
  end

  def add_to_program
    @program = Project.find(params[:program_id])
    @users = User.where(id: params[:user_ids])
    all_user_ids = (@program.project_users.pluck(:user_id) + @users.pluck(:id)).compact.uniq
    @program.user_ids = all_user_ids
    
    if @program.save
      render json: {msg: "Users are added to program successfully!"}, status: 200
    else
      render json: {msg: @program.errors.full_messages.join(",")}, status: 406
    end
  end

  def remove_from_program
    @program = Project.find(params[:program_id])
    @users = User.where(id: params[:user_id])
    user_ids = @users.pluck(:id)
    project_users = @program.project_users.where(user_id: user_ids)
    # all_user_ids = (@program.project_users.pluck(:user_id) - user_ids).compact.uniq
    role_id = Role.program_admin_user_role.id

    program_admin_user_ids = @program.get_program_admin_ids
    if (program_admin_user_ids - user_ids).size < 1
      render json: {msg: "There must be at least 1 program admin exists in program! Please retry."}, status: 406
    else
      # @program.user_ids = all_user_ids
      project_users.destroy_all


      if @program.save
        render json: {msg: "Users are removed from program successfully!"}, status: 200
      else
        render json: {msg: @program.errors.full_messages.join(",")}, status: 406
      end
    end

  end

  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :title)
  end

end
