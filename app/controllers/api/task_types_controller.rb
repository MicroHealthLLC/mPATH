class Api::TaskTypesController < AuthenticatedController

  def index
    render json: {task_types: TaskType.all.as_json}
  end
end
