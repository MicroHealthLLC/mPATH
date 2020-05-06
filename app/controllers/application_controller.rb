class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden, content_type: 'text/html' }
      format.html { redirect_to main_app.root_url, notice: exception.message }
      format.js   { head :forbidden, content_type: 'text/html' }
    end
  end

  def render_404(options={})
    render_error({message: :notice_file_not_found, status: 404}.merge(options))
  end

  def render_error(arg)
    arg = {message: arg} unless arg.is_a?(Hash)

    @message = arg[:message]
    @message = @message if @message.is_a?(Symbol)
    @status = arg[:status] || 500

    respond_to do |format|
      format.any { head @status }
    end
  end

  def require_admin
    render_404 unless current_user.admin?
  end
end
