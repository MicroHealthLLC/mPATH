class Api::V1::FilterDataController < AuthenticatedController
  
  def programs
    response_json = []
    if params[:program_id]
      programs = current_user.projects.active.distinct.includes(:facilities).select(:id, :name).where("projects.id": params[:program_id])
    else
      programs = current_user.projects.active.distinct.includes(:facilities).select(:id, :name)
    end

    facility_group_ids = Facility.joins(:facility_projects).where("facility_projects.project_id" => programs.pluck(:id) ).order("facility_group_id").pluck(:facility_group_id).uniq
    facility_groups = FacilityGroup.select(:id, :name).where(id: facility_group_ids)

    programs.in_batches(of: 1000) do |pp|
      pp.find_each do |p|

        projects_group_by_facility_group = p.facilities.group_by do |f|
          f.facility_group_id
        end.transform_values{|v| v.map{|vv| {id: SecureRandom.hex(2), project_id: vv.id, label: vv.facility_name } } }
        project_children = []
        
        projects_group_by_facility_group.each do |fg_id, facilities|
          fg = facility_groups.detect{|g| g.id == fg_id} 
          project_children << {id: SecureRandom.hex(2), project_group_id: fg.id, label: fg.name, children: facilities }
        end

        h = {
          id: SecureRandom.hex(2),
          program_id: p.id,
          label: p.name,
          children: project_children
        }
        response_json << h
      end
    end
    render json: {portfolio_filters: response_json }
  end

  def users
    response_json = []
    if params[:program_id]
      users = User.joins(:project_users).where(project_users: {project_id: params[:program_id] }).distinct.select(:id, :first_name)
    else
      users = User.joins(:project_users).where(project_users: {project_id: current_user.projects.active.distinct.ids }).distinct.select(:id, :first_name)
    end
    render json: {users: users.map{|u| {id: u.id, name: u.first_name } } }
  end

end