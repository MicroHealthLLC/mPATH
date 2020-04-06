class FacilitiesController < AuthenticatedController
  before_action :set_project
  before_action :set_facility, only: [:show, :update, :destroy]

  def index
    render json: {facilities: @project.facilities.order(created_at: :desc).as_json}
  end

  def create
    @facility = @project.facilities.create(facility_params.merge(creator: current_user))
    render json: {facility: @facility.as_json}
  end

  def show
    render json: {facility: @facility.as_json}
  end

  def update
    @facility.update(facility_params)
    render json: {facility: @facility.as_json}
  end

  def destroy
    @facility.destroy!
    render json: {}, status: 200
  rescue
    render json: {}, status: :not_found
  end

  private
  def set_facility
    @facility = @project.facilities.find_by(id: params[:id])
  end

  def set_project
    @project = current_user.projects.active.find_by(id: params[:project_id])
  end

  def facility_params
    params.require(:facility).permit(
      :facility_name,
      :address,
      :facility_group_id,
      :status_id,
      :point_of_contact,
      :phone_number,
      :email,
      :notes,
      :lat,
      :lng
    )
  end
end
