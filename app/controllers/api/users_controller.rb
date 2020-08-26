class Api::UsersController < AuthenticatedController
  before_action :require_admin

  def index
    render json: User.all.map(&:as_json)
  end
end
