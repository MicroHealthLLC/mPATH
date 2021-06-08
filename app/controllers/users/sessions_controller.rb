class Users::SessionsController < Devise::SessionsController
  protect_from_forgery with: :exception, prepend: true,  unless: -> { request.format.json? }
  def create
    user = User.find_by_email(sign_in_params[:email])

    if user && user.valid_password?(sign_in_params[:password])
      @current_user = user
      if request.format.json?
        render json: { token: user.authentication_token }, status: :ok
      end
    else
      render json: { errors: { 'email or password' => ['is invalid'] } }, status: :unprocessable_entity
    end
  end

  private

  # def respond_with(resource, _opts = {})
  #   render json: { message: 'You are logged in.' }, status: :ok
  # end

  # def respond_to_on_destroy
  #   log_out_success && return if current_user

  #   log_out_failure
  # end

  # def log_out_success
  #   render json: { message: "You are logged out." }, status: :ok
  # end

  # def log_out_failure
  #   render json: { message: "Hmm nothing happened."}, status: :unauthorized
  # end
end