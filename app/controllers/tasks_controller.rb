class TasksController < AuthenticatedController
  before_action :set_resources
  before_action :set_task, only: [:show]

  def index
    render json: {projects: @project.tasks.all.order(created_at: :desc).map(&:as_json)}
  end

  def create
    @task = @project.tasks.create(task_params)
    render json: {task: @task.as_json}
  end

  def show
    render json: {task: @task.as_json}
  end

  private
  def set_resources
    @facility = Facility.find_by(id: params[:facility_id])
    @project = @facility.projects.find_by(id: params[:project_id])
  end

  def set_task
    @task = @project.tasks.find_by(id: params[:id])
  end
  
  def task_params
    params.require(:task).permit(
      :text,
      :task_type,
      :due_date,
      :notes
    )
  end
end
