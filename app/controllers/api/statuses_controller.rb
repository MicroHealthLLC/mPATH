class Api::StatusesController < Api::ApplicationController
  before_action :authenticate_request!

  def index
    render json: {statuses: Status.all.as_json}
  end
end
