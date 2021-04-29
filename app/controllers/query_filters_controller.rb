class QueryFiltersController < AuthenticatedController

  def index
    project = Project.find(params[:project_id])
    filters = project.favorite_filters.includes(:query_filters).where("favorite_filters.user_id = ? or shared = ?",current_user.id, true)
    render json: filters.map(&:to_json)
  end

  # TODO: improve this function
  def create
    p_params = query_filters_params[:query_filters] || []
    fav_params = favorite_filter_params #query_filters_params[:favorite_filter]


    if fav_params.nil? # || p_params.nil? 
      render json: {error: "No filter found"}, status: 403
      return
    end

    begin
      project = Project.find(params[:project_id])

      favorite_filter = nil

      if fav_params[:id].present?
        favorite_filter = project.favorite_filters.where(id: fav_params[:id]).first
        if favorite_filter && !favorite_filter.can_update?(current_user)
          raise CanCan::AccessDenied, "You are not authorized to modify filter"
        else
          if !favorite_filter.update(fav_params)
            render_error({error: favorite_filter.errors.full_messages.join(", ")})
            return
          end
        end
      else
        favorite_filter = FavoriteFilter.new(project_id: project.id, name: fav_params[:name], user_id: current_user.id, shared: fav_params[:shared])

        if !favorite_filter.save
          render_error({error: favorite_filter.errors.full_messages.join(", ")})
          return
        end
      end

      existing_query_filters = project.query_filters.where(user_id: current_user.id, favorite_filter_id: favorite_filter.id)
      existing_query_filter_keys = existing_query_filters.map(&:filter_key).compact.uniq

      query_filters = []
      query_filters_to_remove = []

      p_params.each do |filter|
        f = existing_query_filters.detect{|qf| qf.filter_key == filter[:filter_key] }
        if f.present?
          existing_query_filter_keys.delete(f.filter_key)
          f.update(filter)
        else
          query_filters << QueryFilter.new(filter.merge({project_id: project.id, user_id: current_user.id, favorite_filter_id: favorite_filter.id }))
        end
      end
      if existing_query_filter_keys.any?
        existing_query_filters.map{|f| f.destroy if existing_query_filter_keys.include?(f.filter_key) }
      end
      QueryFilter.import(query_filters) if query_filters.any?

      render json: {favorite_filter: favorite_filter.to_json }

    rescue Exception => e
      render json: {error: e.message }, status: 500
    end
  end

  def reset
    project = Project.find(params[:project_id])
    fav_params = favorite_filter_params

    if fav_params && fav_params[:id].present?
      filter = project.favorite_filters.where(id: fav_params[:id]).first
      if filter
        if !filter.can_update?(current_user)
          raise CanCan::AccessDenied, "You are not authorized to remove filter"
        else
          filter.destroy
          render json: {message: "Filters destroyed successfully", id: filter.id}
        end
      else        
        render json: {error: "No Filter found"}, status: 404
      end
    else
      render json: {error: "Can not found filter without ID"}, status: 404
    end

  end

  def favorite_filter_params
    params.require(:favorite_filter).permit(:name, :id, :shared)
  end
  def query_filters_params
    params.permit(query_filters: [:filter_key, :name, :filter_value])
  end
end
