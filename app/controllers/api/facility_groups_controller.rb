class Api::FacilityGroupsController < AuthenticatedController
  def index
    collection = params[:project_id].present? ? FacilityGroup.joins(:facility_projects).where("facility_projects.project_id = ?", params[:project_id]).distinct : FacilityGroup.all

    render json: {facility_groups: collection.as_json}
  end
end
