class FacilityGroupsController < AuthenticatedController
  def index
    render json: {facility_groups: FacilityGroup.active.as_json}
  end
end
