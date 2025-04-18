class AuthenticatedController < ApplicationController
  # Above code is just for testing purpose. Once the token based authentication is implemented, remove this code.

  protect_from_forgery with: :exception, prepend: true, if: -> {ENV['API_TEST_MODE'].nil? ||  ENV['API_TEST_MODE'] == "false"}
  before_action :authenticate_user!, if: -> {ENV['API_TEST_MODE'].nil? || ENV['API_TEST_MODE'] == "false"}

  if ENV['API_TEST_MODE'].present? && ENV['API_TEST_MODE'] == "true"
    def current_user
      email = request.headers["Email"].present? ? request.headers["Email"] : 'admin@example.com'
      @current_user ||= User.find_by(email: email)
    end
  end

  def check_program_admin
    if !current_user.is_program_admin?(params[:project_id])
      raise CanCan::AccessDenied      
    end
  end
end