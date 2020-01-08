class RegionsController < AuthenticatedController
  
  def index
    render json: {regions: Region.all.map(&:as_json)}
  end
end
