class TasksController < AuthenticatedController
  before_action :set_resources
  before_action :set_task, only: [:show, :update, :destroy, :destroy_file]

  def index
    render json: {tasks: @facility_project.tasks.map(&:to_json)}
  end

  def create
    @task = @facility_project.tasks.create(task_params)
    render json: {task: @task.to_json}
  end

  def update
    @task.update(task_params)
    render json: {task: @task.to_json}
  end

  def show
    render json: {task: @task.to_json}
  end

  def destroy
    @task.destroy!
    render json: {}, status: 200
  rescue
    render json: {}, status: 500
  end

  def destroy_file
    file = @task.task_files.find_by(id: file_params[:id])
    file.purge if file.present?
    render json: {task: @task.to_json}
  end

  private
  def set_resources
    @project = current_user.projects.active.find_by(id: params[:project_id])
    @facility_project = @project.facility_projects.find_by(facility_id: params[:facility_id])
  end

  def set_task
    @task = @facility_project.tasks.find_by(id: params[:id])
  end

  def task_params
    params.require(:task).permit(
      :text,
      :task_type_id,
      :due_date,
      :start_date,
      :notes,
      :progress,
      task_files: [],
      checklists_attributes: [
        :id,
        :_destroy,
        :text,
        :checked
      ]
    )
  end

  def file_params
    params.require(:file).permit(:id, :uri)
  end
end
