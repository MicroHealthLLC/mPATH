class Api::V1::PortfolioController < AuthenticatedController 
# class Api::V1::PortfolioController < Api::ApplicationController
  
  # before_action :authenticate_request!

  def tab_counts
    json_response = {tasks_count: 0, issues_count: 0, risks_count: 0, lessons_count: 0}
    program_ids = authorized_program_ids
    json_response[:tasks_count] = Task.unscoped.joins(:facility_project).where("facility_projects.project_id" => program_ids).count
    json_response[:issues_count] = Issue.unscoped.joins(:facility_project).where("facility_projects.project_id" => program_ids).count
    json_response[:risks_count] = Risk.unscoped.joins(:facility_project).where("facility_projects.project_id" => program_ids).count
    json_response[:lessons_count] =  Lesson.unscoped.joins(:facility_project).where("facility_projects.project_id" => program_ids).count

    render json: json_response
  end

  def lessons
    pph = current_user.project_privileges_hash
    fph = current_user.facility_privileges_hash

    if params[:pagination] && params[:pagination] == "true"
      all_resources = Lesson.unscoped.joins(:facility_project).includes(Lesson.lesson_preload_array).where("facility_projects.project_id" => authorized_program_ids ).paginate(per_page: params[:per_page], page: params[:page])
      facility_project_hash = FacilityProject.where(id: all_resources.pluck(:facility_project_id).uniq).group_by(&:id)

      json_response = []
      all_resources.each do |resource|
        
        project_id = facility_project_hash[resource.facility_project_id].first.facility_id
        program_id = facility_project_hash[resource.facility_project_id].first.project_id

        if current_user.has_permission?(resource: 'lessons', program: program_id, project: project_id, project_privileges_hash: pph, facility_privileges_hash: fph)
          json_response << resource.portfolio_json
        end

      end
      render json: {lessons: json_response, total_count: all_resources.total_entries, next_page: all_resources.next_page, current_page: all_resources.current_page, previous_page: all_resources.previous_page }
    else
      program_ids = authorized_program_ids
      all_resources = Lesson.unscoped.joins(:facility_project).includes(Lesson.lesson_preload_array).where("facility_projects.project_id" => program_ids )
      facility_project_hash = FacilityProject.where(id: all_resources.pluck(:facility_project_id).uniq).group_by(&:id)
      json_response = []
      all_resources.in_batches(of: 1000) do |resources|
        resources.find_each do |resource|
          project_id = facility_project_hash[resource.facility_project_id].first.facility_id
          program_id = facility_project_hash[resource.facility_project_id].first.project_id

          if current_user.has_permission?(resource: 'lessons', program: program_id, project: project_id, project_privileges_hash: pph, facility_privileges_hash: fph)
            json_response << resource.portfolio_json
          end
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
    pph = current_user.project_privileges_hash
    fph = current_user.facility_privileges_hash

    if params[:pagination] && params[:pagination] == "true"
      all_resources = Task.unscoped.joins(:facility_project).includes([{task_files_attachments: :blob}, :task_type, :task_users, {users: :organization}, :task_stage, {checklists: [:user, {progress_lists: :user} ] }, { notes: :user }, :related_tasks, :related_issues, :related_risks, :sub_tasks, :sub_issues, :sub_risks, :project, :facility, :facility_group, {facility_project: [:facility, :status] } ]).where("facility_projects.project_id" => authorized_program_ids).paginate(per_page: params[:per_page], page: params[:page])
      facility_project_hash = FacilityProject.where(id: all_resources.pluck(:facility_project_id).uniq).group_by(&:id)

      json_response = []
      all_resources.each do |resource|
        project_id = facility_project_hash[resource.facility_project_id].first.facility_id
        program_id = facility_project_hash[resource.facility_project_id].first.project_id
  
        if current_user.has_permission?(resource: 'tasks', program: program_id, project: project_id, project_privileges_hash: pph, facility_privileges_hash: fph)
          json_response << resource.portfolio_json
        end
      end

      render json: {tasks: json_response, total_count: all_resources.total_entries, next_page: all_resources.next_page, current_page: all_resources.current_page, previous_page: all_resources.previous_page }

    else
      program_ids = authorized_program_ids
      all_resources = Task.unscoped.joins(:facility_project).includes([{task_files_attachments: :blob}, :task_type, :task_users, {users: :organization}, :task_stage, {checklists: [:user, {progress_lists: :user} ] }, { notes: :user }, :related_tasks, :related_issues, :related_risks, :sub_tasks, :sub_issues, :sub_risks, :project, :facility, :facility_group, {facility_project: [:facility, :status]} ]).where("facility_projects.project_id" => program_ids)
      facility_project_hash = FacilityProject.where(id: all_resources.pluck(:facility_project_id).uniq).group_by(&:id)

      json_response = []

      all_resources.in_batches(of: 1000) do |resources|
        resources.find_each do |resource|
          project_id = facility_project_hash[resource.facility_project_id].first.facility_id
          program_id = facility_project_hash[resource.facility_project_id].first.project_id
    
          if current_user.has_permission?(resource: 'tasks', program: program_id, project: project_id, project_privileges_hash: pph, facility_privileges_hash: fph)
            json_response << resource.portfolio_json
          end
        end
      end
      render json: {tasks: json_response, total_count: json_response.size, next_page: nil, current_page: nil, previous_page: nil }
    end

  end

  def issues
    pph = current_user.project_privileges_hash
    fph = current_user.facility_privileges_hash

    if params[:pagination] && params[:pagination] == "true"

      all_resources = Issue.unscoped.joins(:facility_project).includes([{issue_files_attachments: :blob}, :issue_type, :task_type, :issue_users, {users: :organization}, :issue_stage, {checklists: [:user, {progress_lists: :user} ] },  { notes: :user }, :related_tasks, :related_issues,:related_risks, :sub_tasks, :sub_issues, :sub_risks, :project, :facility, :facility_group, {facility_project: [:facility, :status]}, :issue_severity ]).where("facility_projects.project_id" => authorized_program_ids).paginate(per_page: params[:per_page], page: params[:page])
      facility_project_hash = FacilityProject.where(id: all_resources.pluck(:facility_project_id).uniq).group_by(&:id)

      json_response = []
      all_resources.each do |resource|
        project_id = facility_project_hash[resource.facility_project_id].first.facility_id
        program_id = facility_project_hash[resource.facility_project_id].first.project_id
  
        if current_user.has_permission?(resource: 'issues', program: program_id, project: project_id, project_privileges_hash: pph, facility_privileges_hash: fph)
          json_response << resource.portfolio_json
        end
      end
      render json: {issues: json_response, total_count: all_resources.total_entries, next_page: all_resources.next_page, current_page: all_resources.current_page, previous_page: all_resources.previous_page }

    else
      program_ids = authorized_program_ids
      all_resources = Issue.unscoped.joins(:facility_project).includes([{issue_files_attachments: :blob}, :issue_type, :task_type, :issue_users, {users: :organization}, :issue_stage, {checklists: [:user, {progress_lists: :user} ] },  { notes: :user }, :related_tasks, :related_issues,:related_risks, :sub_tasks, :sub_issues, :sub_risks, :project, :facility, :facility_group, {facility_project: [:facility, :status]}, :issue_severity ]).where("facility_projects.project_id" => program_ids)
      facility_project_hash = FacilityProject.where(id: all_resources.pluck(:facility_project_id).uniq).group_by(&:id)

      json_response = []
      all_resources.in_batches(of: 1000) do |resources|
        resources.find_each do |resource|
          project_id = facility_project_hash[resource.facility_project_id].first.facility_id
          program_id = facility_project_hash[resource.facility_project_id].first.project_id
    
          if current_user.has_permission?(resource: 'issues', program: program_id, project: project_id, project_privileges_hash: pph, facility_privileges_hash: fph)
            json_response << resource.portfolio_json
          end
        end
      end
      render json: {issues: json_response, total_count: json_response.size, next_page: nil, current_page: nil, previous_page: nil }
    end

  end

  def risks
    pph = current_user.project_privileges_hash
    fph = current_user.facility_privileges_hash

    if params[:pagination] && params[:pagination] == "true"
      all_resources = Risk.unscoped.joins(:facility_project).includes([{risk_files_attachments: :blob}, :task_type, :risk_users, {users: :organization},:risk_stage, {checklists: [:user, {progress_lists: :user} ] },  { notes: :user }, :related_tasks, :related_issues,:related_risks, :sub_tasks, :sub_issues, :sub_risks, :project, :facility, :facility_group, {facility_project: [:facility, :status]} ]).where("facility_projects.project_id" => authorized_program_ids).paginate(per_page: params[:per_page], page: params[:page])
      facility_project_hash = FacilityProject.where(id: all_resources.pluck(:facility_project_id).uniq).group_by(&:id)

      json_response = []
      all_resources.each do |resource|
        project_id = facility_project_hash[resource.facility_project_id].first.facility_id
        program_id = facility_project_hash[resource.facility_project_id].first.project_id
  
        if current_user.has_permission?(resource: 'risks', program: program_id, project: project_id, project_privileges_hash: pph, facility_privileges_hash: fph)
          json_response << resource.portfolio_json
        end
      end
      render json: {risks: json_response, total_count: all_resources.total_entries, next_page: all_resources.next_page, current_page: all_resources.current_page, previous_page: all_resources.previous_page }
    else
      program_ids = authorized_program_ids

      all_resources = Risk.unscoped.joins(:facility_project).includes([{risk_files_attachments: :blob}, :task_type, :risk_users, {users: :organization},:risk_stage, {checklists: [:user, {progress_lists: :user} ] },  { notes: :user }, :related_tasks, :related_issues,:related_risks, :sub_tasks, :sub_issues, :sub_risks, :project, :facility, :facility_group, {facility_project: [:facility, :status]} ]).where("facility_projects.project_id" => program_ids)
      facility_project_hash = FacilityProject.where(id: all_resources.pluck(:facility_project_id).uniq).group_by(&:id)

      json_response = []
      all_resources.in_batches(of: 1000) do |resources|
        resources.find_each do |resource|
          project_id = facility_project_hash[resource.facility_project_id].first.facility_id
          program_id = facility_project_hash[resource.facility_project_id].first.project_id
    
          if current_user.has_permission?(resource: 'risks', program: program_id, project: project_id, project_privileges_hash: pph, facility_privileges_hash: fph)
            json_response << resource.portfolio_json
          end
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
