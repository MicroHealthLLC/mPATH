class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def office365
    check_omniauth_auth
  end

  def google_oauth2
    check_omniauth_auth
  end

  def keycloak_openid
    #  Rails.logger.debug "OmniAuth auth data: #{request.env['omniauth.auth'].inspect}"
    #   Rails.logger.debug "Request environment: #{request.env.inspect}"
    #   Rails.logger.debug "Incoming request parameters: #{params.inspect}"
    #   session[:keycloakstate] = request.env["omniauth.auth"]["uid"]
    check_omniauth_auth
  end

  def okta
    Rails.logger.debug "OmniAuth auth data: #{request.env['omniauth.auth'].inspect}"
    session[:oktastate] = request.env["omniauth.auth"]["uid"]
    check_omniauth_auth
  end

  def passthru
    Rails.logger.debug "Passthru path: #{request.fullpath}"
    respond_to do |format|
      format.html { render status: 404, text: "Not found. Authentication passthru." }
    end    
  end
  
  def failure
    set_flash_message :alert, :failure, kind: OmniAuth::Utils.camelize(failed_strategy.name), reason: failure_message
    redirect_to after_omniauth_failure_path_for(resource_name)
  end


  private
    def check_omniauth_auth
      @user = User.from_omniauth(request.env["omniauth.auth"])
      redirect_to new_user_session_path, alert: "You dont have access rights!" and return if @user.nil?
      sign_in_and_redirect(@user)
    end

  protected

  def failed_strategy
    request.respond_to?(:get_header) ? request.get_header("omniauth.error.strategy") : request.env["omniauth.error.strategy"]
  end

  def failure_message
    exception = request.respond_to?(:get_header) ? request.get_header("omniauth.error") : request.env["omniauth.error"]
    error = exception.error_reason if exception.respond_to?(:error_reason)
    error ||= exception.error if exception.respond_to?(:error)
    error ||= (request.respond_to?(:get_header) ? request.get_header("omniauth.error.type") : request.env["omniauth.error.type"]).to_s
    error.to_s.humanize if error
  end

  def after_omniauth_failure_path_for(scope)
    new_session_path(scope)
  end

  def translation_scope
    'devise.omniauth_callbacks'
  end
end
