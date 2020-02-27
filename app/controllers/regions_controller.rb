class RegionsController < AuthenticatedController
  def index
    render json: {regions: Region.active.as_json}
  end
end
