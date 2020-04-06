class ProjectsController < AuthenticatedController
  before_action :set_project, only: [:show, :destroy, :update]

  def index
    respond_to do |format|
      format.json { render json: {projects: current_user.projects.active.order(created_at: :desc).as_json}, status: 200 }
      format.html {}
    end
  end

  def show
    unless @project.nil?
      respond_to do |format|
        format.json { render json: {project: @project}, status: 200 }
        format.html { render action: :index }
      end
    else
      respond_to do |format|
        format.json { render json: {}, status: :not_found }
        format.html { render 'layouts/_not_found', locals: { message: "Project with id #{params[:id]} doesn't exists" } }
      end
    end
  end

  private
  def set_project
    @project = current_user.projects.active.find_by(id: params[:id])
  end
end
