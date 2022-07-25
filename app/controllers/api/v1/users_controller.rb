class Api::V1::UsersController < AuthenticatedController
  before_action :require_admin, except: [:index]

  def index
    @users = []    
    status_code = 200
    if params[:project_id].present? && current_user.is_program_admin?(params[:project_id])
      @users = Project.where(id: params[:project_id]).first.users.includes(:organization).as_json
    elsif current_user.has_program_admin_role?
      @users = User.active.map(&:as_json)
    else
      status_code = 406
    end
    render json: @users, status: status_code
  end

  def create
    @user = User.new(user_params)
    @user.password =  ENV['NEW_USER_PASSWORD'] || SecureRandom.hex(7)
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
      render json: {errors: @user.errors.full_messages.join(",")}, status: 406
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
      render json: {errors: @program.errors.full_messages.join(",")}, status: 406
    end
  end

  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :title)
  end

end
