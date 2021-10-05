class Api::ProjectsController < AuthenticatedController
  before_action :require_admin

  def index

  end
end
