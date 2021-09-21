class Api::V1::FilterDataController < AuthenticatedController
  
  def programs
    response_json = []
    program_ids = params[:program_id] ? [ params[:program_id] ] : current_user.authorized_programs.distinct.ids

    programs = current_user.authorized_programs.distinct.includes({facility_projects: :facility}).select(:id, :name).where("projects.id": program_ids )

    facility_group_ids = Facility.joins(:facility_projects).where("facility_projects.project_id" => programs.pluck(:id) ).order("facility_group_id").pluck(:facility_group_id).uniq
    facility_groups = FacilityGroup.select(:id, :name).where(id: facility_group_ids)

    programs.in_batches(of: 1000) do |pp|
      pp.find_each do |p|

        projects_group_by_facility_group = p.facility_projects.group_by do |f|
          f.facility.facility_group_id
        end.transform_values{|v| v.map{|vv| {id: SecureRandom.uuid, project_id: vv.facility.id, label: vv.facility.facility_name, facility_project_id: vv.id } } }
        project_children = []
        
        projects_group_by_facility_group.each do |fg_id, facilities|
          fg = facility_groups.detect{|g| g.id == fg_id} 
          fp_ids = facilities.map{|h| h[:facility_project_id]}.compact.uniq
          project_children << {id: SecureRandom.uuid, project_group_id: fg.id, label: fg.name, all_facility_project_ids: fp_ids, children: facilities }
        end

        h = {
          id: SecureRandom.uuid,
          program_id: p.id,
          label: p.name,
          all_facility_project_ids: project_children.map{|h| h[:all_facility_project_ids]}.flatten.compact.uniq,
          children: project_children
        }
        response_json << h
      end
    end
    render json: {portfolio_filters: response_json }
  end

  def users
    response_json = []
    program_ids = params[:program_id] ? [ params[:program_id] ] : current_user.authorized_programs.distinct.ids

    users = User.joins(:project_users).where(project_users: {project_id: program_ids}).active.distinct.select(:id, :first_name, :last_name)

    render json: {users: users.map{|u| {id: u.id, name: u.full_name } } }
  end

  def statuses
    response_json = []
    program_ids = params[:program_id] ? [ params[:program_id] ] : current_user.authorized_programs.distinct.ids
    statues = Status.joins(:project_statuses).where(project_statuses: {project_id: program_ids }).distinct.select(:id, :name)
    render json: {statuses: statues.map{|u| {id: u.id, name: u.name } } }
  end

  def categories
    response_json = []
    program_ids = params[:program_id] ? [ params[:program_id] ] : current_user.authorized_programs.distinct.ids

    task_types = TaskType.joins(:project_task_types).where(project_task_types: {project_id: program_ids }).distinct.select(:id, :name)
    render json: {categories: task_types.map{|u| {id: u.id, name: u.name } } }
  end

  def stages
    response_json = []
    resource_name = params[:resource] || "task"
    stages = []
    program_ids = params[:program_id] ? [ params[:program_id] ] : current_user.authorized_programs.distinct.ids
    if resource_name == "task"
      # stages = TaskStage.joins(:project_task_stages).where(project_task_stages: {project_id: program_ids }).distinct.select(:id, :name, :percentage)
      # binding.pry
      stages = ProjectTaskStage.includes(:task_stage).where(project_id: program_ids).group_by{|p| p.project_id}.transform_values{|v| v.map(&:task_stage).compact.map{|ts| ts.attributes.except("created_at", "updated_at") } }

    elsif resource_name == "issue"
      # stages = IssueStage.joins(:project_issue_stages).where(project_issue_stages: {project_id: program_ids }).distinct.select(:id, :name, :percentage)
      stages = ProjectIssueStage.includes(:issue_stage).where(project_id: program_ids).group_by{|p| p.project_id}.transform_values{|v| v.map(&:issue_stage).compact.map{|ts| ts.attributes.except("created_at", "updated_at") } }

    elsif resource_name == "risk"
      # stages = RiskStage.joins(:project_risk_stages).where(project_risk_stages: {project_id: program_ids }).distinct.select(:id, :name, :percentage)
      stages = ProjectRiskStage.includes(:risk_stage).where(project_id: program_ids).group_by{|p| p.project_id}.transform_values{|v| v.map(&:risk_stage).compact.map{|ts| ts.attributes.except("created_at", "updated_at") } }
      
    elsif resource_name == "lesson"
      # stages = LessonStage.joins(:project_lesson_stages).where(project_lesson_stages: {project_id: program_ids }).distinct.select(:id, :name)
      stages = ProjectLessonStage.includes(:lesson_stage).where(project_id: program_ids).group_by{|p| p.project_id}.transform_values{|v| v.map(&:lesson_stage).compact.map{|ts| ts.attributes.except("created_at", "updated_at") } }
    end
    render json: {stages: stages}
  end

  def issue_types
    response_json = []
    stages = []
    program_ids = params[:program_id] ? [ params[:program_id] ] : current_user.authorized_programs.distinct.ids
    issue_types = IssueType.joins(:project_issue_types).where(project_issue_types: {project_id: program_ids }).distinct.select(:id, :name)

    render json: {issue_types: issue_types}
  end

  def issue_severities
    response_json = []
    stages = []
    program_ids = params[:program_id] ? [ params[:program_id] ] : current_user.authorized_programs.distinct.ids
    issue_severities = IssueSeverity.joins(:project_issue_severities).where(project_issue_severities: {project_id: program_ids }).distinct.select(:id, :name)

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
      {id: 'very low', value: 'very low', name: 'Very Low 1'},
      {id: 'low', value: 'low', name: 'Low 2 - 3'},
      {id: 'moderate', value: 'moderate', name: 'Moderate 4 - 6'},
      {id: 'high', value: 'high', name: 'High 8 - 12'},
      {id: 'extreme', value: 'extreme', name: 'Extreme 15 - 25'}
    ]
    render json: {risk_priorities: risk_priority_levels}
  end

end