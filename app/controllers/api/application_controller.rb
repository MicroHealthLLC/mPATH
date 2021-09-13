class Api::ApplicationController < ActionController::API
  before_action :authenticate_request!
  around_action :user_time_zone, if: :current_user

  attr_reader :current_user

  after_action :release_memory#, if: -> {Rails.env.development?}
  
  # Custom Error pages.
  rescue_from NameError, Exception, with: lambda { |exception| render_error(exception.message, 500) }
  rescue_from ActionController::RoutingError, ::AbstractController::ActionNotFound, with: lambda { |exception| render_error(exception.message, 404) }
  rescue_from ActiveRecord::RecordNotFound, with: lambda { |exception| render_error("Record not found", 404,{e: exception}) }

  rescue_from CanCan::AccessDenied, with: lambda {|exception| render_error(exception.message,403) }

  protected

  def release_memory
    GC.start
    MallocTrim.trim
  end
  
  def user_time_zone(&block)
    Time.use_zone('Eastern Time (US & Canada)' , &block)
  end

  def render_error(error_msg = "Error occurred!", status_code = 500, options = {})
    render json: {error: error_msg},  status: status_code
  end

  def authenticate_request!
    unless user_id_in_token?
      render json: { errors: ['Not Authenticated'] }, status: :unauthorized
      return
    end
    @current_user = User.find(auth_token[:user_id])
  rescue JWT::VerificationError, JWT::DecodeError
    render json: { errors: ['Not Authenticated'] }, status: :unauthorized
  end

  private
  def http_token
    @http_token ||= ( request.headers['Authorization'].present? ?  request.headers['Authorization'].split(' ').last : nil)
  end
  
  def auth_token
    @auth_token ||= JsonWebToken.decode(http_token)
  end

  def user_id_in_token?
    http_token && auth_token && auth_token[:user_id].to_i
  end

end