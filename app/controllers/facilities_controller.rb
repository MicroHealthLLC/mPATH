class FacilitiesController < AuthenticatedController
  before_action :set_project
  before_action :set_facility, only: [:show, :update, :destroy]

  def index
    render json: {facilities: @project.facility_projects.order(created_at: :desc).as_json, project: @project}
  end

  def create
    @facility = @project.facilities.create(facility_params.merge(creator: current_user))
    render json: {facility: @facility.as_json}
  end

  def show
    render json: {facility: @facility_project.as_json}
  end

  def update
    @facility_project.update(facility_project_params)
    render json: {facility: @facility_project.as_json}
  end

  def destroy
    @facility.destroy!
    render json: {}, status: 200
  rescue
    render json: {}, status: :not_found
  end

  private
  def set_facility
    @facility_project = @project.facility_projects.find_by(facility_id: params[:id])
    @facility = @facility_project.facility
  end

  def set_project
    @project = current_user.projects.active.find_by(id: params[:project_id])
  end

  def facility_params
    params.require(:facility).permit(
      :facility_name,
      :address,
      :facility_group_id,
      :point_of_contact,
      :phone_number,
      :email,
      :lat,
      :lng
    )
  end

  def facility_project_params
    params.require(:facility).permit(
      :status_id,
      :due_date
    )
  end
end
