class Api::V1::FilterDataController < AuthenticatedController
  
  def programs
    response_json = []
    program_ids = params[:program_id] ? [ params[:program_id] ] : current_user.projects.active.distinct.ids

    programs = current_user.projects.active.distinct.includes(:facilities).select(:id, :name).where("projects.id": program_ids )

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
    program_ids = params[:program_id] ? [ params[:program_id] ] : current_user.projects.active.distinct.ids

    users = User.joins(:project_users).where(project_users: {project_id: program_ids}).distinct.select(:id, :first_name, :last_name)

    render json: {users: users.map{|u| {id: u.id, name: u.full_name } } }
  end

  def statuses
    response_json = []
    program_ids = params[:program_id] ? [ params[:program_id] ] : current_user.projects.active.distinct.ids
    statues = Status.joins(:project_statuses).where(project_statuses: {project_id: program_ids }).distinct.select(:id, :name)
    render json: {statuses: statues.map{|u| {id: u.id, name: u.name } } }
  end

  def categories
    response_json = []
    program_ids = params[:program_id] ? [ params[:program_id] ] : current_user.projects.active.distinct.ids

    task_types = TaskType.joins(:project_task_types).where(project_task_types: {project_id: program_ids }).distinct.select(:id, :name)
    render json: {categories: task_types.map{|u| {id: u.id, name: u.name } } }
  end

  def stages
    response_json = []
    resource_name = params[:resource] || "task"
    stages = []
    program_ids = params[:program_id] ? [ params[:program_id] ] : current_user.projects.active.distinct.ids
    if resource_name == "task"
      stages = TaskStage.joins(:project_task_stages).where(project_task_stages: {project_id: program_ids }).distinct.select(:id, :name)
    elsif resource_name == "issue"
      stages = IssueStage.joins(:project_issue_stages).where(project_issue_stages: {project_id: program_ids }).distinct.select(:id, :name)
    elsif resource_name == "risk"
      stages = RiskStage.joins(:project_risk_stages).where(project_risk_stages: {project_id: program_ids }).distinct.select(:id, :name)
    end
    render json: {stages: stages}
  end

  def issue_types
    response_json = []
    stages = []
    program_ids = params[:program_id] ? [ params[:program_id] ] : current_user.projects.active.distinct.ids
    issue_types = IssueType.joins(:project_issue_types).where(project_issue_types: {project_id: program_ids }).distinct.select(:id, :name)

    render json: {issue_types: issue_types}
  end

  def issue_severities
    response_json = []
    stages = []
    program_ids = params[:program_id] ? [ params[:program_id] ] : current_user.projects.active.distinct.ids
    issue_severities = IssueSeverities.joins(:project_issue_severities).where(project_issue_severities: {project_id: program_ids }).distinct.select(:id, :name)

    render json: {issue_severities: issue_severities}
  end

  def risk_approaches
    risk_approaches = [
      {id: 'accept', name: 'Accept', value: 'accept'},
      {id: 'avoid', name: 'Avoid', value: 'avoid'},
      {id: 'mitigate', name: 'Mitigate', value: "mitigate"},
      {id: 'transfer', name: 'Transfer', value: "transfer"},
    ]
    render json: {risk_approaches: risk_approaches}
  end

  def risk_priority_level
    risk_priority_levels = [
      {id: 1, value: 1, name: "1 - Negligible"},
      {id: 2, value: 2, name: "2 - Minor"},
      {id: 3, value: 3, name: "3 - Moderate"},
      {id: 4, value: 4, name: "4 - Major"},
      {id: 5, value: 5, name: "5 - Catastrophic"}
    ]
    render json: {risk_approaches: risk_priority_levels}
  end

end