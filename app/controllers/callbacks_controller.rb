class CallbacksController < Devise::OmniauthCallbacksController
  def office365
    check_omniauth_auth
  end

  def google_oauth2
    check_omniauth_auth
  end

  private
    def check_omniauth_auth
      @user = User.from_omniauth(request.env["omniauth.auth"])
      sign_in_and_redirect(@user)
    end
end
