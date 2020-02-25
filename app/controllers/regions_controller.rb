class RegionsController < AuthenticatedController
  before_action :set_project
  
  def index
    render json: {regions: Region.active.as_json}
  end

  private
  def set_project
    @project = current_user.projects.find_by(id: params[:project_id])
  end
end
