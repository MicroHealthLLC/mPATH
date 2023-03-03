class Api::V1::ProjectsController < AuthenticatedController 
# class Api::V1::ProjectsController < Api::ApplicationController
  before_action :set_project, only: [:destroy, :update, :gantt_chart, :watch_view, :member_list, :facility_manager, :sheet, :calendar]
  # before_action :authenticate_request!

  def project_efforts
    facility_project_ids = FacilityProject.where(project_id: params[:program_id]).pluck(:id)
    
    all_project_users = Project.find(params[:program_id]).users
    facility_projects = FacilityProject.includes(:facility).where(project_id: params[:program_id])
    if params[:date_of_week]
      all_efforts = Effort.includes([ {resource: :facility_project}, :user, {facility_project: :facility} ]).where("efforts.facility_project_id in (?) and date_of_week between ? and ?", facility_project_ids, Date.parse(params[:date_of_week]).in_time_zone(Time.zone).beginning_of_day, Date.parse(params[:date_of_week]).in_time_zone(Time.zone).end_of_day )
    else
      all_efforts = Effort.includes([ {resource: :facility_project}, :user, {facility_project: :facility} ]).where("efforts.facility_project_id in (?)", facility_project_ids)
    end
    effort_by_users = all_efforts.group_by{|t| t.user}

    # total_pages = all_efforts.total_pages
    # current_page = all_efforts.current_page
    # next_page = all_efforts.next_page

    response = []

    all_project_users.each do |user|
      user_hash = user.as_json
      user_hash[:facilities] = []
      efforts = effort_by_users[user] || []
      effort_task_ids = efforts.map(&:resource_id).uniq
      t_facility_projects = efforts.map(&:facility_project).uniq
      fp_array = []
      
      effort_by_tasks = efforts.group_by{|t| t.resource }
      tasks = effort_by_tasks.keys
      tasks_by_facility_project = tasks.group_by{|task, efforts| task.facility_project_id }

      t_facility_projects.each do |fp|
        tasks = tasks_by_facility_project[fp.id] || []
        fp_hash = fp.facility.attributes
        fp_hash[:tasks] = []
        tasks.each do |task|
          fp_hash[:tasks] << task.as_json.merge(efforts: effort_by_tasks[task])
        end
        
        fp_array << fp_hash
      end
      user_hash[:facilities] = fp_array

      response << user_hash

    end

    # render json: {efforts: response, total_pages: total_pages, current_page: current_page, next_page: next_page }
    render json: {efforts: response }
  end

  def task_issues
    collection = Project.find_by(id: params[:id]).as_json(include: {tasks: {only: [:text, :id]}, issues: {only: [:title, :id]}, risks: {only: [:risk_description, :id]}})
    render json: collection
  end

  def index
    render json: {projects: current_user.authorized_programs.includes(:project_type).as_json}
  end

  def show
    @project = current_user.authorized_programs.find_by(id: params[:id])
    check_permit("map_view")
    unless @project.nil?
      render json: {project: @project.build_json_response(current_user)}, status: 200
     else
      render json: {error: "Project not found"}, status: :not_found
    end
  end

  private
  def set_project
      fg_hash = {
        facility_projects: [:facility, {
          tasks: [{task_files_attachments: :blob}, :task_type, :users, :task_stage, {checklists: :progress_lists}, :notes, :related_tasks, :related_issues, :sub_tasks, :sub_issues, {facility_project: :facility} ]
          }, {
          issues: [{issue_files_attachments: :blob}, :issue_type, :users, :issue_stage, {checklists: :progress_lists}, :notes, :related_tasks, :related_issues, :sub_tasks, :sub_issues, {facility_project: :facility}, :issue_severity ]
          }, {
            notes: [{note_files_attachments: :blob}, :user]
          }
        ]
      }
      fp_hash = {
        facility: [:facility_group],
        tasks: [{task_files_attachments: :blob}, :task_type, :users, :task_stage, {checklists: :progress_lists}, :notes, :related_tasks, :related_issues, :sub_tasks, :sub_issues, {facility_project: :facility} ],
        issues: [{issue_files_attachments: :blob}, :issue_type, :users, :issue_stage, {checklists: :progress_lists}, :notes, :related_tasks, :related_issues, :sub_tasks, :sub_issues, {facility_project: :facility}, :issue_severity ],
        notes: [{note_files_attachments: :blob}, :user]
      }
      projects_include_hash = {
        users: [],     
        facility_projects: fp_hash,
        facility_groups: fg_hash,
        statuses: [],
        task_types: [],
        issue_types: [],
        issue_severities: []
      }
    @project = current_user.authorized_programs.includes(projects_include_hash).find_by(id: params[:id])
  end

  def check_permit(view)
    return unless current_user.allowed?(view)
  end

  def resolve_layout
    case action_name
    when "index" then "portfolio_viewer"
    else "application"
    end
  end

end
