class Api::V1::Portfolio::PortfolioController < AuthenticatedController 
# class Api::V1::PortfolioController < Api::ApplicationController
  
  # before_action :authenticate_request!

  def tab_counts
    json_response = {tasks_count: 0, issues_count: 0, risks_count: 0, lessons_count: 0}
    all_facility_project_ids = current_user.authorized_facility_project_ids

    facility_project_ids_with_project_tasks = current_user.role_users.joins(:role_privileges).where("role_privileges.privilege REGEXP '^[RWD]' and role_users.facility_project_id in (?) and role_privileges.role_type = ?", all_facility_project_ids, RolePrivilege::PROJECT_TASKS).select("distinct(facility_project_id)").map(&:facility_project_id)

    facility_project_ids_with_project_issues = current_user.role_users.joins(:role_privileges).where("role_privileges.privilege REGEXP '^[RWD]' and role_users.facility_project_id in (?) and role_privileges.role_type = ?", all_facility_project_ids, RolePrivilege::PROJECT_ISSUES).select("distinct(facility_project_id)").map(&:facility_project_id)
    
    facility_project_ids_with_project_risks = current_user.role_users.joins(:role_privileges).where("role_privileges.privilege REGEXP '^[RWD]' and role_users.facility_project_id in (?) and role_privileges.role_type = ?", all_facility_project_ids, RolePrivilege::PROJECT_RISKS).select("distinct(facility_project_id)").map(&:facility_project_id)
    
    facility_project_ids_with_project_lessons = current_user.role_users.joins(:role_privileges).where("role_privileges.privilege REGEXP '^[RWD]' and role_users.facility_project_id in (?) and role_privileges.role_type = ?", all_facility_project_ids, RolePrivilege::PROJECT_LESSONS).select("distinct(facility_project_id)").map(&:facility_project_id)

    json_response[:tasks_count] = Task.unscoped.where("tasks.facility_project_id in (?)", facility_project_ids_with_project_tasks).count
    json_response[:issues_count] = Issue.unscoped.where("issues.facility_project_id in (?)", facility_project_ids_with_project_issues).count
    json_response[:risks_count] = Risk.unscoped.where("risks.facility_project_id in (?)", facility_project_ids_with_project_risks).count
    json_response[:lessons_count] =  Lesson.unscoped.where("lessons.facility_project_id in (?)", facility_project_ids_with_project_lessons).count

    render json: json_response
  end

  def lessons

    facility_project_ids = current_user.authorized_facility_project_ids
    facility_project_ids_with_project_lessons = current_user.role_users.joins(:role_privileges).where("role_privileges.privilege REGEXP '^[RWD]' and role_users.facility_project_id in (?) and role_privileges.role_type = ?", facility_project_ids, RolePrivilege::PROJECT_LESSONS).select("distinct(facility_project_id)").map(&:facility_project_id)

    if params[:pagination] && params[:pagination] == "true"
      all_resources = Lesson.unscoped.where("lessons.facility_project_id in (?)", facility_project_ids_with_project_lessons).paginate(per_page: params[:per_page], page: params[:page])

      json_response = []
      all_resources.includes(Lesson.lesson_preload_array).find_each do |resource|
        json_response << resource.portfolio_json
      end
      render json: {lessons: json_response, total_count: all_resources.total_entries, next_page: all_resources.next_page, current_page: all_resources.current_page, previous_page: all_resources.previous_page, total_pages: all_resources.total_pages }
    else
      all_resources = Lesson.unscoped.where("lessons.facility_project_id in (?)", facility_project_ids_with_project_lessons)

      json_response = []
      all_resources.includes(Lesson.lesson_preload_array).find_each do |resource|
        json_response << resource.portfolio_json
      end
      render json: {lessons: json_response, total_count: json_response.size, next_page: nil, current_page: nil, previous_page: nil, total_pages: nil }
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
      all_resources.find_each do |resource|
        json_response << resource.portfolio_json
      end
      render json: json_response
    end

  end

  def tasks

    facility_project_ids = current_user.authorized_facility_project_ids
    facility_project_ids_with_project_tasks = current_user.role_users.joins(:role_privileges).where("role_privileges.privilege REGEXP '^[RWD]' and role_users.facility_project_id in (?) and role_privileges.role_type = ?", facility_project_ids, RolePrivilege::PROJECT_TASKS).select("distinct(facility_project_id)").map(&:facility_project_id)

    if params[:pagination] && params[:pagination] == "true"

      all_resources = Task.unscoped.where("tasks.facility_project_id in (?)", facility_project_ids_with_project_tasks).paginate(per_page: params[:per_page], page: params[:page])

      json_response = []
      all_resources.includes([{task_files_attachments: :blob}, :task_type, :task_users, {users: :organization}, :task_stage, {checklists: [:user, {progress_lists: :user} ] }, { notes: :user }, :related_tasks, :related_issues, :related_risks, :sub_tasks, :sub_issues, :sub_risks, :facility_group, :contract_facility_group, :contract_project, :project, :contract_project_data, :facility, {facility_project: [:facility, :status]} ]).find_each do |resource|
          json_response << resource.portfolio_json
        end

      render json: {tasks: json_response, total_count: all_resources.total_entries, next_page: all_resources.next_page, current_page: all_resources.current_page, previous_page: all_resources.previous_page, total_pages: all_resources.total_pages }

    else

      all_resources = Task.unscoped.where("tasks.facility_project_id in (?)", facility_project_ids_with_project_tasks)

      json_response = []
      all_resources.includes([{task_files_attachments: :blob}, :task_type, :task_users, {users: :organization}, :task_stage, {checklists: [:user, {progress_lists: :user} ] }, { notes: :user }, :related_tasks, :related_issues, :related_risks, :sub_tasks, :sub_issues, :sub_risks, :facility_group, :contract_facility_group, :contract_project, :project, :contract_project_data, :facility, {facility_project: [:facility, :status]} ]).find_each do |resource|
        json_response << resource.portfolio_json
      end

      render json: {tasks: json_response, total_count: json_response.size, next_page: nil, current_page: nil, previous_page: nil, total_pages: nil }
    end

  end

  def issues
    
    facility_project_ids = current_user.authorized_facility_project_ids
    facility_project_ids_with_project_issues = current_user.role_users.joins(:role_privileges).where("role_privileges.privilege REGEXP '^[RWD]' and role_users.facility_project_id in (?) and role_privileges.role_type = ?", facility_project_ids, RolePrivilege::PROJECT_ISSUES).select("distinct(facility_project_id)").map(&:facility_project_id)

    if params[:pagination] && params[:pagination] == "true"

      all_resources = Issue.unscoped.where("issues.facility_project_id in (?)", facility_project_ids_with_project_issues).paginate(per_page: params[:per_page], page: params[:page])

      json_response = []
      all_resources.includes([{issue_files_attachments: :blob}, :issue_type, :task_type, :issue_users, {users: :organization}, :issue_stage, {checklists: [:user, {progress_lists: :user} ] },  { notes: :user }, :related_tasks, :related_issues,:related_risks, :sub_tasks, :sub_issues, :sub_risks, :project, :facility, :facility_group, {facility_project: [:facility, :status]}, :issue_severity ]).find_each do |resource|
          json_response << resource.portfolio_json
      end
        
      render json: {issues: json_response, total_count: all_resources.total_entries, next_page: all_resources.next_page, current_page: all_resources.current_page, previous_page: all_resources.previous_page, total_pages: all_resources.total_pages }

    else
      all_resources = Issue.unscoped.where("issues.facility_project_id in (?)", facility_project_ids_with_project_issues)

      json_response = []
      all_resources.includes([{issue_files_attachments: :blob}, :issue_type, :task_type, :issue_users, {users: :organization}, :issue_stage, {checklists: [:user, {progress_lists: :user} ] },  { notes: :user }, :related_tasks, :related_issues,:related_risks, :sub_tasks, :sub_issues, :sub_risks, :project, :facility, :facility_group, {facility_project: [:facility, :status]}, :issue_severity ]).find_each do |resource|
          json_response << resource.portfolio_json
      end
      render json: {issues: json_response, total_count: json_response.size, next_page: nil, current_page: nil, previous_page: nil , total_pages: nil }
    end

  end

  def risks

    facility_project_ids = current_user.authorized_facility_project_ids
    facility_project_ids_with_project_risks = current_user.role_users.joins(:role_privileges).where("role_privileges.privilege REGEXP '^[RWD]' and role_users.facility_project_id in (?) and role_privileges.role_type = ?", facility_project_ids, RolePrivilege::PROJECT_RISKS).select("distinct(facility_project_id)").map(&:facility_project_id)

    if params[:pagination] && params[:pagination] == "true"
      all_resources = Risk.unscoped.where("risks.facility_project_id in (?)", facility_project_ids_with_project_risks).paginate(per_page: params[:per_page], page: params[:page])

      json_response = []
      all_resources.includes([{risk_files_attachments: :blob}, :task_type, :risk_users, {users: :organization},:risk_stage, {checklists: [:user, {progress_lists: :user} ] },  { notes: :user }, :related_tasks, :related_issues,:related_risks, :sub_tasks, :sub_issues, :sub_risks, :project, :facility, :facility_group, {facility_project: [:facility, :status]} ]).find_each do |resource|
        json_response << resource.portfolio_json
      end

      render json: {risks: json_response, total_count: all_resources.total_entries, next_page: all_resources.next_page, current_page: all_resources.current_page, previous_page: all_resources.previous_page, total_pages: all_resources.total_pages }
    else

      all_resources = Risk.unscoped.where("risks.facility_project_id in (?)", facility_project_ids_with_project_risks)

      json_response = []
      all_resources.includes([{risk_files_attachments: :blob}, :task_type, :risk_users, {users: :organization},:risk_stage, {checklists: [:user, {progress_lists: :user} ] },  { notes: :user }, :related_tasks, :related_issues,:related_risks, :sub_tasks, :sub_issues, :sub_risks, :project, :facility, :facility_group, {facility_project: [:facility, :status]} ]).find_each do |resource|
        json_response << resource.portfolio_json
      end

      render json: {risks: json_response, total_count: json_response.size, next_page: nil, current_page: nil, previous_page: nil, total_pages: nil }
    end

  end

end
