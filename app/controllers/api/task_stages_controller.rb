class Api::TaskStagesController < AuthenticatedController
  def index
    render json: {task_stages: TaskStage.all.as_json}
  end
end
