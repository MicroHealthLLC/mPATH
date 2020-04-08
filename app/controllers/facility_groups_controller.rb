class FacilityGroupsController < AuthenticatedController
  def index
    render json: {facility_groups: FacilityGroup.all.as_json}
  end
end
