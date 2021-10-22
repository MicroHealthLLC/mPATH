class Api::V1::Admin::StatusesController < AuthenticatedController
  # before_action :authenticate_request!

  def index
    render json: {statuses: Status.all.as_json}
  end
end
