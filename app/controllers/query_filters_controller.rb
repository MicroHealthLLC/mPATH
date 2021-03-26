class QueryFiltersController < AuthenticatedController

  def create
    project = Project.find(params[:project_id])
    p_params = query_filters_params
    existing_query_filters = project.query_filters
    query_filters = []
    p_params[:query_filters].each do |filter|
      f = existing_query_filters.detect{|qf| qf.filter_key == filter[:filter_key] }

      if f.present?
        f.update(filter)
      else
        query_filters << QueryFilter.new(filter.merge({project_id: project.id}))
      end
    end
    QueryFilter.import(query_filters) if query_filters.any?
  end

  def query_filters_params
    params.permit!
  end

end
