class RegionsController < AuthenticatedController
  
  def index
    render json: { regions: Region.where(region_type: :region).as_json }
  end
end
