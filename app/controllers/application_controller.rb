class ApplicationController < ActionController::Base
  around_action :user_time_zone, if: :current_user

  after_action :release_memory#, if: -> {Rails.env.development?}

  rescue_from NameError, Exception, with: lambda { |exception| render_error(exception, 500) }
  rescue_from ActionController::RoutingError, with: lambda { |exception| render_error(exception, 404) }
  rescue_from ::AbstractController::ActionNotFound, with: lambda { |exception| render_error(exception, 404) }

  rescue_from ActiveRecord::RecordNotFound, with: lambda { |exception| render_error(exception, 404,{e: exception}) }

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json {render json: {error: exception.message} , status: 401}
      format.html {redirect_to main_app.root_url, notice: exception.message}
      format.js {head :forbidden, content_type: 'text/html'}
    end
  end


  def release_memory
    GC.start
    MallocTrim.trim
  end

  def after_sign_in_path_for(resource_or_scope)
    current_user.preference_url
  end

  def render_404(options={})
    # render_error({message: :notice_file_not_found, status: 404}.merge(options))
    render_error("Record not found",404)
  end

  def raise_403
    raise CanCan::AccessDenied.new("Not authorized!")
  end

  def render_error(error_obj = Exception.new("Error occurred!"), status_code = 500, options = {})
    if error_obj.is_a?(Exception)
      error_msg = error_obj.message
      Rails.logger.error error_obj.message
      Rails.logger.error error_obj.backtrace.join("\n")
    elsif error_obj.is_a?(String)
      error_msg = error_obj
    else
      error_msg = "Error occurred!"
    end

    render json: {error: error_msg},  status: status_code
  end

  # def render_error(arg)
  #   arg = {message: arg} unless arg.is_a?(Hash)

  #   @message = arg[:message]
  #   @message = @message if @message.is_a?(Symbol)
  #   @status = arg[:status] || 500
  #   arg[:status] ||= 500

  #   respond_to do |format|
  #     #format.any {head @status}
  #     format.any { render(json: arg,  status: @status) }
  #   end
  # end

  def require_admin
    render_404 unless current_user.admin?
  end

  def user_time_zone(&block)
    Time.use_zone('Eastern Time (US & Canada)' , &block)
  end
end
