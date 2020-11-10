class ProjectsController < AuthenticatedController
  before_action :set_project, only: [:show, :destroy, :update, :gantt_chart, :watch_view, :member_list, :facility_manager, :sheets]

  def index
    respond_to do |format|
      format.json {render json: {projects: current_user.projects.active.order(created_at: :desc).as_json}, status: 200}
      format.html {}
    end
  end

  def show
    check_permit("map_view")
    unless @project.nil?
      respond_to do |format|
        format.json {render json: {project: @project, users: @project.users}, status: 200}
        format.html {render action: :index}
      end
    else
      respond_to do |format|
        format.json {render json: {}, status: :not_found}
        format.html {render 'layouts/_not_found', locals: {message: "Project with id #{params[:id]} doesn't exists"}}
      end
    end
  end

  def gantt_chart
    check_permit("gantt_view")
    respond_to do |format|
      format.json {}
      format.html {render action: :index}
    end
  end

  def watch_view
    check_permit("watch_view")
    respond_to do |format|
      format.json {}
      format.html {render action: :index}
    end
  end

  def member_list
    check_permit("members")
    respond_to do |format|
      format.json {}
      format.html {render action: :index}
    end
  end

  def facility_manager
    check_permit("facility_manager_view")
    respond_to do |format|
      format.json {}
      format.html {render action: :index}
    end
  end

  def sheets
    check_permit("sheets_view")
    respond_to do |format|
      format.json {}
      format.html {render action: :index}
    end
  end

  private
  def set_project
    @project = current_user.projects.active.find_by(id: params[:id])
  end

  def check_permit(view)
    raise_403 and return unless current_user.allowed?(view)
  end
end
