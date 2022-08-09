class AuthenticatedController < ApplicationController
  # Above code is just for testing purpose. Once the token based authentication is implemented, remove this code.

  protect_from_forgery with: :exception, prepend: true, if: -> {ENV['TEST_MODE'].nil? ||  ENV['TEST_MODE'] == "false"}
  before_action :authenticate_user!, if: -> {ENV['TEST_MODE'].nil? || ENV['TEST_MODE'] == "false"}

  if ENV['TEST_MODE'].present? && ENV['TEST_MODE'] == "true"
    def current_user
      if params[:email]
        email = params[:email]
      elsif request.headers["Email"].present?
        email = request.headers["Email"]
      else
        email = 'admin@example.com'
      end

      @current_user ||= User.find_by(email: email)
    end
  end

  def check_program_admin
    if !current_user.is_program_admin?(params[:project_id])
      raise CanCan::AccessDenied      
    end
  end
end