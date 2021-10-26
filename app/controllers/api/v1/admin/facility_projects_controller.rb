class Api::V1::Admin::FacilityProjectsController < AuthenticatedController
  before_action :require_admin

  def index
    collection = FacilityProject.find_by(project_id: params[:project_id], facility_id: params[:facility_id]).as_json(include: {tasks: {only: [:text, :id]}, issues: {only: [:title, :id]}})
    render json: collection
  end
  
  def show
    @facility_project = FacilityProject.where(project_id: params[:project_id], facility_id: params[:id]).limit(1)[0]
    render json: @facility_project.build_json_response
    # render json: @facility_project.as_json(include: {project: {only: :name}}, methods: [:status_name])
  end

  def update
    @facility_project.update(facility_params)
    render json: @facility_project.as_json(include: {project: {only: :name}}, methods: [:status_name])
  end

  private
  def set_facility_project
    @facility_project = @facility.facility_projects.find_by(id: params[:id])
  end

  def set_facility
    @facility = Facility.find_by(id: params[:facility_id])
  end

  def facility_params
    params.require(:facility_project).permit(
      :due_date,
      :status_id
    )
  end
end
