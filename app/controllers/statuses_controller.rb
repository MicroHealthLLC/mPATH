class StatusesController < AuthenticatedController

  def index
    render json: {statuses: Status.all.as_json}
  end
end
