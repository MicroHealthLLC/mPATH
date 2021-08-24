class Api::V1::PortfolioController < AuthenticatedController 
# class Api::V1::PortfolioController < Api::ApplicationController
  
  # before_action :authenticate_request!

  def tab_counts
    json_response = {tasks_count: 0, issues_count: 0, risks_count: 0, lessons_count: 0}
    
    json_response[:tasks_count] = Task.unscoped.joins(:facility_project).where("facility_projects.project_id" => current_user.project_ids).count
    json_response[:issues_count] = Issue.unscoped.joins(:facility_project).where("facility_projects.project_id" => current_user.project_ids).count
    json_response[:risks_count] = Risk.unscoped.joins(:facility_project).where("facility_projects.project_id" => current_user.project_ids).count
    json_response[:lessons_count] =  Lesson.unscoped.joins(:facility_project).where("facility_projects.project_id" => current_user.project_ids).count

    render json: json_response
  end

  def lessons
    if params[:pagination] && params[:pagination] == "true"
      all_resources = Lesson.unscoped.joins(:facility_project).includes(Lesson.lesson_preload_array).where("facility_projects.project_id" => authorized_program_ids ).paginate(per_page: 15, page: params[:page])
      json_response = []
      all_resources.each do |resource|
        json_response << resource.portfolio_json
      end
      render json: json_response
    else
      all_resources = Lesson.unscoped.joins(:facility_project).includes(Lesson.lesson_preload_array).where("facility_projects.project_id" => authorized_program_ids )
      json_response = []
      all_resources.in_batches(of: 1000) do |resources|
        resources.find_each do |resource|
          json_response << resource.portfolio_json
        end        
      end
      render json: json_response
    end

  end

  def programs

    if params[:pagination] && params[:pagination] == "true"
      all_resources = current_user.authorized_programs.includes(:tasks, :issues, :risks).paginate(per_page: 15, page: params[:page])
      json_response = []
      all_resources.each do |resources|
        json_response << resource.portfolio_json
      end
      render json: json_response
    else
      all_resources = current_user.authorized_programs.includes(:tasks, :issues, :risks)
      json_response = []
      all_resources.in_batches(of: 1000) do |resources|
        resources.find_each do |resource|
          json_response << resource.portfolio_json
        end
      end
      render json: json_response
    end

  end

  def tasks

    if params[:pagination] && params[:pagination] == "true"
      all_resources = Task.unscoped.joins(:facility_project).includes([{task_files_attachments: :blob}, :task_type, :task_users, {users: :organization}, :task_stage, {checklists: [:user, {progress_lists: :user} ] }, { notes: :user }, :related_tasks, :related_issues, :related_risks, :sub_tasks, :sub_issues, :sub_risks, :project, :facility, :facility_group, {facility_project: [:facility, :status] } ]).where("facility_projects.project_id" => authorized_program_ids).paginate(per_page: 15, page: params[:page])
      json_response = []
      all_resources.each do |resource|
        json_response << resource.portfolio_json
      end
      render json: json_response

    else
      all_resources = Task.unscoped.joins(:facility_project).includes([{task_files_attachments: :blob}, :task_type, :task_users, {users: :organization}, :task_stage, {checklists: [:user, {progress_lists: :user} ] }, { notes: :user }, :related_tasks, :related_issues, :related_risks, :sub_tasks, :sub_issues, :sub_risks, :project, :facility, :facility_group, {facility_project: [:facility, :status]} ]).where("facility_projects.project_id" => authorized_program_ids)
      json_response = []

      all_resources.in_batches(of: 1000) do |resources|
        resources.find_each do |resource|
          json_response << resource.portfolio_json
        end
      end
      render json: json_response
    end

  end

  def issues

    if params[:pagination] && params[:pagination] == "true"

      all_resources = Issue.unscoped.joins(:facility_project).includes([{issue_files_attachments: :blob}, :issue_type, :task_type, :issue_users, {users: :organization}, :issue_stage, {checklists: [:user, {progress_lists: :user} ] },  { notes: :user }, :related_tasks, :related_issues,:related_risks, :sub_tasks, :sub_issues, :sub_risks, :project, :facility, :facility_group, {facility_project: [:facility, :status]}, :issue_severity ]).where("facility_projects.project_id" => authorized_program_ids).paginate(per_page: 15, page: params[:page])
      json_response = []
      all_resources.each do |resource|
        json_response << resource.portfolio_json
      end
      render json: json_response

    else
      all_resources = Issue.unscoped.joins(:facility_project).includes([{issue_files_attachments: :blob}, :issue_type, :task_type, :issue_users, {users: :organization}, :issue_stage, {checklists: [:user, {progress_lists: :user} ] },  { notes: :user }, :related_tasks, :related_issues,:related_risks, :sub_tasks, :sub_issues, :sub_risks, :project, :facility, :facility_group, {facility_project: [:facility, :status]}, :issue_severity ]).where("facility_projects.project_id" => authorized_program_ids)
      json_response = []
      all_resources.in_batches(of: 1000) do |resources|
        resources.find_each do |resource|
          json_response << resource.portfolio_json
        end
      end
      render json: json_response
    end

  end

  def risks
    pph = current_user.project_privileges_hash
    fph = current_user.facility_privileges_hash

    if params[:pagination] && params[:pagination] == "true"
      all_resources = Risk.unscoped.joins(:facility_project).includes([{risk_files_attachments: :blob}, :task_type, :risk_users, {users: :organization},:risk_stage, {checklists: [:user, {progress_lists: :user} ] },  { notes: :user }, :related_tasks, :related_issues,:related_risks, :sub_tasks, :sub_issues, :sub_risks, :project, :facility, :facility_group, {facility_project: [:facility, :status]} ]).where("facility_projects.project_id" => authorized_program_ids).paginate(per_page: 15, page: params[:page])
      json_response = []
      all_resources.each do |resource|
        json_response << resource.portfolio_json
      end
      render json: json_response
    else
      all_resources = Risk.unscoped.joins(:facility_project).includes([{risk_files_attachments: :blob}, :task_type, :risk_users, {users: :organization},:risk_stage, {checklists: [:user, {progress_lists: :user} ] },  { notes: :user }, :related_tasks, :related_issues,:related_risks, :sub_tasks, :sub_issues, :sub_risks, :project, :facility, :facility_group, {facility_project: [:facility, :status]} ]).where("facility_projects.project_id" => authorized_program_ids)
      json_response = []
      all_resources.in_batches(of: 1000) do |resources|
        resources.find_each do |resource|
          json_response << resource.portfolio_json
        end
      end
      render json: json_response
    end

  end

  private
  def authorized_program_ids
    current_user.authorized_programs.pluck(:id)
  end
end
