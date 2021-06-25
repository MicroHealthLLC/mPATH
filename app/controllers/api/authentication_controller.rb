class API::V1::AuthenticationController < ApplicationController
  skip_before_action :authenticate_user!
  
  # TODO replace with JWT
  def sign_in
    user = User.where("LOWER(email) = ?", sign_in_params[:email].to_s.downcase).first
    
    if user&.valid_password?(sign_in_params[:password])
      render :json => {
        user_id: user.id,
        email: user.email,
        authentication_token: user.encrypted_authentication_token
      }.to_json, :status => 200
    else
      render :json => {error: "invalid-credentials"}.to_json, :status => 401
    end
    
  end
  
  private
    def sign_in_params
      params.require(:user).permit(:email, :password)
    end
end