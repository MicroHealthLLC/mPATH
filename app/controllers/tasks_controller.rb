class TasksController < AuthenticatedController
  before_action :set_resources
  before_action :set_task, only: [:show, :update, :destroy]

  def index
    render json: {tasks: @facility_project.tasks.map(&:to_json)}
  end

  def create
    @task = @facility_project.tasks.create(task_params)
    render json: {task: @task.to_json}
  end

  def update
    destroy_files_first if destroy_file_ids.present?
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
      :description,
      :progress,
      :auto_calculate,
      :watched,
      task_files: [],
      user_ids: [],
      sub_task_ids: [],
      sub_issue_ids: [],
      checklists_attributes: [
        :id,
        :_destroy,
        :text,
        :user_id,
        :checked
      ],
      notes_attributes: [
        :id,
        :_destroy,
        :user_id,
        :body
      ]
    )
  end

  def destroy_file_ids
    params[:task][:destroy_file_ids]&.split(',')&.map(&:to_i)
  end

  def destroy_files_first
    @task.task_files.where(id: destroy_file_ids)&.map(&:purge)
  end
end
