class Api::V1::UsersController < AuthenticatedController
  before_action :require_admin

  def index
    if params[:project_id].present?
      @users = Project.where(id: params[:project_id]).first.users.as_json
    else
      @users = User.active.map(&:as_json)
    end
    render json: @users
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

  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :title)
  end

end
