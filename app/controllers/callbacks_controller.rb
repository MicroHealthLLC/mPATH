class CallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token

  def office365
    # check_omniauth_auth
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "Office 365") if is_navigational_format?
    else
      session["devise.office365_data"] = request.env["omniauth.auth"].except(:extra)
      redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
    end
  end

  def google_oauth2
    check_omniauth_auth
  end

  def oktaoauth
    session[:oktastate] = request.env["omniauth.auth"]["uid"]
    check_omniauth_auth
  end

  private
    def check_omniauth_auth
      @user = User.from_omniauth(request.env["omniauth.auth"])
      redirect_to new_user_session_path, alert: "You dont have access rights!" and return if @user.nil?
      sign_in_and_redirect(@user)
    end
end
