class Api::V1::FilterDataController < AuthenticatedController
  
  def programs
    response_json = []

    programs = current_user.projects.active.includes(:facility_groups, :facilities, :facility_projects).select(:id, :name)
    programs.in_batches(of: 1000) do |pp|
      pp.find_each do |p|
        g = p.facility_groups
        projects_group_by_facility_group = p.facilities.group_by{|f| f.facility_group_id }.transform_values{|v| v.map{|vv| {id: vv.id, label: vv.facility_name } } }

        h = {
          id: p.id,
          label: p.name,
          children: g.map{|gg| {id: gg.id, label: gg.name, children: projects_group_by_facility_group[gg.id] } }
        }
        response_json << h
      end
    end
    render json: {portfolio_filters: response_json }
  end

end