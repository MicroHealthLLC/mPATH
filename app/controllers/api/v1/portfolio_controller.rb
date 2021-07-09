class Api::V1::PortfolioController < AuthenticatedController 
  before_action :authenticate_user!

  def programs
    all_resources = current_user.projects.active
    json_response = []
    all_resources.in_batches(of: 1000) do |resources|
      json_response += resources.map(&:porfolio_json)
    end
    render json: json_response
  end


  def tasks
    all_resources = Task.joins(:facility_project).unscoped.includes([{task_files_attachments: :blob}, :task_type, :task_users, {users: :organization}, :task_stage, {checklists: [:user, {progress_lists: :user} ] }, { notes: :user }, :related_tasks, :related_issues, :related_risks, :sub_tasks, :sub_issues, :sub_risks, :project, :facility, {facility_project: :facility} ]).where("facility_projects.project_id" => current_user.project_ids)
    json_response = []
    all_resources.in_batches(of: 1000) do |resources|
      json_response += resources.map(&:porfolio_json)
    end
    render json: json_response
  end

  def issues
    all_resources = Issue.joins(:facility_project).unscoped.includes([{issue_files_attachments: :blob}, :issue_type, :task_type, :issue_users, {users: :organization}, :issue_stage, {checklists: [:user, {progress_lists: :user} ] },  { notes: :user }, :related_tasks, :related_issues,:related_risks, :sub_tasks, :sub_issues, :sub_risks, :project, :facility, {facility_project: :facility}, :issue_severity ]).where("facility_projects.project_id" => current_user.project_ids)
    json_response = []
    all_resources.in_batches(of: 1000) do |resources|
      json_response += resources.map(&:porfolio_json)
    end
    render json: json_response
  end

  def risks
    all_resources = Risk.joins(:facility_project).unscoped.includes([{risk_files_attachments: :blob}, :task_type, :risk_users, {users: :organization},:risk_stage, {checklists: [:user, {progress_lists: :user} ] },  { notes: :user }, :related_tasks, :related_issues,:related_risks, :sub_tasks, :sub_issues, :sub_risks, :project, :facility, {facility_project: :facility} ]).where("facility_projects.project_id" => current_user.project_ids)
    json_response = []
    all_resources.in_batches(of: 1000) do |resources|
      json_response += resources.map(&:porfolio_json)
    end
    render json: json_response
  end

  def lessons
    all_resources = Lesson.joins(:facility_project).unscoped.includes(Lesson.lesson_preload_array).where("facility_projects.project_id" => current_user.project_ids)
    json_response = []
    all_resources.in_batches(of: 1000) do |resources|
      json_response += resources.map(&:porfolio_json)
    end
    render json: json_response
  end

end
