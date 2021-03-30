class QueryFiltersController < AuthenticatedController

  def index
    project = Project.find(params[:project_id])
    render json: project.query_filters.where(user_id: current_user.id).map(&:to_json)
  end

  def create
    if query_filters_params[:query_filters].nil?
      render json: {error: "No filter found"}, status: 403
      return
    end

    project = Project.find(params[:project_id])
    p_params = query_filters_params
    existing_query_filters = project.query_filters.where(user_id: current_user.id)
    query_filters = []

    p_params[:query_filters].each do |filter|
      f = existing_query_filters.detect{|qf| qf.filter_key == filter[:filter_key] }
      if f.present?
        f.update(filter)
      else
        query_filters << QueryFilter.new(filter.merge({project_id: project.id, user_id: current_user.id}))
      end
    end
    QueryFilter.import(query_filters) if query_filters.any?

    render json: query_filters
  end

  def reset
    project = Project.find(params[:project_id])
    project.query_filters.where(user_id: current_user.id).destroy_all
    render json: {message: "Filters destroyed successfully"}
  end

  def query_filters_params
    params.permit!
  end

end
