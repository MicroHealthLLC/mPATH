class Api::FacilityProjectsController < AuthenticatedController
  before_action :require_admin

  def index
    collection = FacilityProject.find_by(project_id: params[:project_id], facility_id: params[:facility_id]).as_json(include: {tasks: {only: [:text, :id]}, issues: {only: [:title, :id]}})
    render json: collection
  end
end
