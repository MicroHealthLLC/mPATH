class AuthenticatedController < ApplicationController
  # Above code is just for testing purpose. Once the token based authentication is implemented, remove this code.

  protect_from_forgery with: :exception, prepend: true, if: -> {ENV['API_TEST_MODE'].nil? ||  ENV['API_TEST_MODE'] == "false"}
  before_action :authenticate_user!, if: -> {ENV['API_TEST_MODE'].nil? || ENV['API_TEST_MODE'] == "false"}

  if ENV['API_TEST_MODE'].present? && ENV['API_TEST_MODE'] == "true"
    def current_user
      @current_user ||= User.find_by(email: 'admin@example.com')
    end
  end

end
