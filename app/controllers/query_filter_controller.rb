class QueryFilterController < AuthenticatedController

  def create
    project = Project.find(params[:id])
    query_filters = []
    params[:query_filters].each do |filter|
      
    end
  end

end
