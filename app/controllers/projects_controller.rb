class ProjectsController < AuthenticatedController
  before_action :set_project, only: [:show, :destroy, :update, :gantt_chart, :watch_view, :member_list]

  def index
    respond_to do |format|
      format.json {render json: {projects: current_user.projects.active.order(created_at: :desc).as_json}, status: 200}
      format.html {}
    end
  end

  def show
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
    respond_to do |format|
      format.json {}
      format.html {render action: :index}
    end
  end

  def watch_view
    respond_to do |format|
      format.json {}
      format.html {render action: :index}
    end
  end

  def member_list; end

  private
  def set_project
    @project = current_user.projects.active.find_by(id: params[:id])
  end
end
