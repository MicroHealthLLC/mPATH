class Api::V1::PortfolioController < AuthenticatedController 
# class Api::V1::PortfolioController < Api::ApplicationController
  
  # before_action :authenticate_request!

  def tab_counts
    json_response = {tasks_count: 0, issues_count: 0, risks_count: 0, lessons_count: 0}
    program_ids = authorized_program_ids
    fph = current_user.authorized_facility_project_id_hash

    if fph[:tasks].any?
      # json_response[:tasks_count] = Task.unscoped.joins(:facility_project).where("facility_projects.project_id" => program_ids).count
      json_response[:tasks_count] = Task.unscoped.where("facility_project_id" => fph[:tasks]).count
    end
    if fph[:issues].any?
      json_response[:issues_count] = Issue.unscoped.where("facility_project_id" => fph[:issues]).count

      # json_response[:issues_count] = Issue.unscoped.joins(:facility_project).where("facility_projects.project_id" => program_ids).count
    end
    if fph[:risks].any?
      json_response[:risks_count] = Risk.unscoped.where("facility_project_id" => fph[:risks]).count

      # json_response[:risks_count] = Risk.unscoped.joins(:facility_project).where("facility_projects.project_id" => program_ids).count

    end
    if fph[:lessons].any?
      json_response[:lessons_count] =  Lesson.unscoped.where("facility_project_id" => fph[:lessons]).count

      # json_response[:lessons_count] =  Lesson.unscoped.joins(:facility_project).where("facility_projects.project_id" => program_ids).count
    end

    render json: json_response
  end

  def lessons

    afph = current_user.authorized_facility_project_id_hash

    if params[:pagination] && params[:pagination] == "true"

      all_resources = Lesson.unscoped.where("facility_project_id" => afph[:tasks].uniq).paginate(per_page: params[:per_page], page: params[:page])

      json_response = []

      all_resources.includes(Lesson.lesson_preload_array).each do |resource|
        json_response << resource.portfolio_json
      end

      render json: {lessons: json_response,total_count: all_resources.total_entries, next_page: all_resources.next_page, current_page: all_resources.current_page, previous_page: all_resources.previous_page }

    else

      all_resources = Lesson.unscoped.where("facility_project_id" => afph[:tasks].uniq)
      json_response = []

      all_resources.in_batches(of: 1000) do |resources|
        
        resources.includes(Lesson.lesson_preload_array).each do |resource|
          
          json_response << resource.portfolio_json
        end      
      end

      render json: {lessons: json_response, total_count: json_response.size, next_page: nil, current_page: nil, previous_page: nil }
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

    afph = current_user.authorized_facility_project_id_hash

    if params[:pagination] && params[:pagination] == "true"

      all_resources = Task.unscoped.where("facility_project_id" => afph[:tasks].uniq).paginate(per_page: params[:per_page], page: params[:page])

      json_response = []

      all_resources.includes([{task_files_attachments: :blob}, :task_type, :task_users, {users: :organization}, :task_stage, {checklists: [:user, {progress_lists: :user} ] }, { notes: :user }, :related_tasks, :related_issues, :related_risks, :sub_tasks, :sub_issues, :sub_risks, :project, :facility, :facility_group, {facility_project: [:facility, :status] } ]).each do |resource|
        json_response << resource.portfolio_json
      end

      render json: {tasks: json_response, current_count: json_response.size,  current_count2: all_resources.count, total_count: all_resources.total_entries, next_page: all_resources.next_page, current_page: all_resources.current_page, previous_page: all_resources.previous_page }

    else

      all_resources = Task.unscoped.where("facility_project_id" => afph[:tasks].uniq)
      json_response = []

      all_resources.in_batches(of: 1000) do |resources|
        
        resources.includes([{task_files_attachments: :blob}, :task_type, :task_users, {users: :organization}, :task_stage, {checklists: [:user, {progress_lists: :user} ] }, { notes: :user }, :related_tasks, :related_issues, :related_risks, :sub_tasks, :sub_issues, :sub_risks, :project, :facility, :facility_group, {facility_project: [:facility, :status] } ]).each do |resource|
          
          json_response << resource.portfolio_json
        end      
      end

      render json: {tasks: json_response, total_count: json_response.size, next_page: nil, current_page: nil, previous_page: nil }
    end

  end

  def issues

    afph = current_user.authorized_facility_project_id_hash

    if params[:pagination] && params[:pagination] == "true"

      all_resources = Issue.unscoped.where("facility_project_id" => afph[:issues].uniq).paginate(per_page: params[:per_page], page: params[:page])

      json_response = []

      all_resources.includes([{issue_files_attachments: :blob}, :issue_type, :task_type, :issue_users, {users: :organization}, :issue_stage, {checklists: [:user, {progress_lists: :user} ] },  { notes: :user }, :related_tasks, :related_issues,:related_risks, :sub_tasks, :sub_issues, :sub_risks, :project, :facility, :facility_group, {facility_project: [:facility, :status]}, :issue_severity ]).each do |resource|
        json_response << resource.portfolio_json
      end

      render json: {issues: json_response, total_count: all_resources.total_entries, next_page: all_resources.next_page, current_page: all_resources.current_page, previous_page: all_resources.previous_page }

    else

      all_resources = Issue.unscoped.where("facility_project_id" => afph[:issues].uniq)
      json_response = []

      all_resources.in_batches(of: 1000) do |resources|
        resources.includes([{issue_files_attachments: :blob}, :issue_type, :task_type, :issue_users, {users: :organization}, :issue_stage, {checklists: [:user, {progress_lists: :user} ] },  { notes: :user }, :related_tasks, :related_issues,:related_risks, :sub_tasks, :sub_issues, :sub_risks, :project, :facility, :facility_group, {facility_project: [:facility, :status]}, :issue_severity ]).each do |resource|
          
          json_response << resource.portfolio_json
        end      
      end

      render json: {issues: json_response, total_count: json_response.size, next_page: nil, current_page: nil, previous_page: nil }

    end

  end

  def risks
    pph = current_user.project_privileges_hash
    fph = current_user.facility_privileges_hash

    afph = current_user.authorized_facility_project_id_hash


    if params[:pagination] && params[:pagination] == "true"


      all_resources = Risk.unscoped.where("facility_project_id" => afph[:issues].uniq).paginate(per_page: params[:per_page], page: params[:page])

      json_response = []

      all_resources.includes([{risk_files_attachments: :blob}, :task_type, :risk_users, {users: :organization},:risk_stage, {checklists: [:user, {progress_lists: :user} ] },  { notes: :user }, :related_tasks, :related_issues,:related_risks, :sub_tasks, :sub_issues, :sub_risks, :project, :facility, :facility_group, {facility_project: [:facility, :status]} ]).each do |resource|
        json_response << resource.portfolio_json
      end

      render json: {risks: json_response, total_count: all_resources.total_entries, next_page: all_resources.next_page, current_page: all_resources.current_page, previous_page: all_resources.previous_page }

    else


      all_resources = Risk.unscoped.where("facility_project_id" => afph[:issues].uniq)
      json_response = []

      all_resources.in_batches(of: 1000) do |resources|
        resources.includes([{risk_files_attachments: :blob}, :task_type, :risk_users, {users: :organization},:risk_stage, {checklists: [:user, {progress_lists: :user} ] },  { notes: :user }, :related_tasks, :related_issues,:related_risks, :sub_tasks, :sub_issues, :sub_risks, :project, :facility, :facility_group, {facility_project: [:facility, :status]} ]).each do |resource|
          
          json_response << resource.portfolio_json
        end      
      end

      render json: {risks: json_response, total_count: json_response.size, next_page: nil, current_page: nil, previous_page: nil }

    end

  end

  private
  def authorized_program_ids
    current_user.authorized_programs.pluck(:id)
  end
end
