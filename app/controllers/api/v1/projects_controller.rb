class Api::V1::ProjectsController < AuthenticatedController 
# class Api::V1::ProjectsController < Api::ApplicationController
  before_action :set_project, only: [:destroy, :update, :gantt_chart, :watch_view, :member_list, :facility_manager, :sheet, :calendar]
  # before_action :authenticate_request!

  def timesheet_count

    beginning_of_year = Date.today.beginning_of_year()
    current_friday = beginning_of_year
    prev_friday = beginning_of_year
    all_week_timesheets = []
    facility_project_ids = FacilityProject.where(project_id: params[:program_id]).pluck(:id)

    while ( current_friday - beginning_of_year).to_i < 365 do
      prev_friday = prev_friday == current_friday ? current_friday : (current_friday + 1) 
      current_friday = current_friday.next_occurring(:friday)
      if ( current_friday - beginning_of_year).to_i < 365
        # count = Timesheet.where("timesheets.facility_project_id in (?) and DATE(date_of_week) between ? and ? and timesheets.hours > 0", facility_project_ids, prev_friday.in_time_zone(Time.zone).beginning_of_day, current_friday.in_time_zone(Time.zone).end_of_day).sum(:hours)


        count = Timesheet.where("timesheets.facility_project_id in (?) and DATE(date_of_week) = ? and timesheets.hours > 0", facility_project_ids, current_friday).sum(:hours)

        all_week_timesheets << {range: "#{prev_friday} - #{current_friday}", friday: current_friday,count: count.to_f}
      end
    end
    render json: {timesheet_count: all_week_timesheets }

  end

  def project_timesheets
    facility_project_ids = FacilityProject.where(project_id: params[:program_id]).pluck(:id)
    
    all_project_users = Project.find(params[:program_id]).users.includes(:organization)
    facility_projects = FacilityProject.includes(:facility).where(project_id: params[:program_id])
    if params[:date_of_week]
      # all_timesheets = Timesheet.includes([ {user: [:organization] }, {facility_project: :facility} ]).where("timesheets.facility_project_id in (?) and DATE(date_of_week) between ? and ? and timesheets.hours > 0", facility_project_ids, Date.parse(params[:date_of_week]).in_time_zone(Time.zone).beginning_of_day, Date.parse(params[:date_of_week]).in_time_zone(Time.zone).end_of_day )
      all_timesheets = Timesheet.includes([ {user: [:organization] }, {facility_project: :facility} ]).where("timesheets.facility_project_id in (?) and DATE(date_of_week) = ? and timesheets.hours > 0", facility_project_ids, Date.parse(params[:date_of_week]) )
    else
      all_timesheets = Timesheet.includes([ {user: [:organization] }, {facility_project: :facility} ]).where("timesheets.facility_project_id in (?) and timesheets.hours > 0", facility_project_ids)
    end

    preloader = ActiveRecord::Associations::Preloader.new
    preloader.preload(all_timesheets.select { |p| p.resource_type == 'Task' }, resource: [:notes])

    # total_pages = all_timesheets.total_pages
    # current_page = all_timesheets.current_page
    # next_page = all_timesheets.next_page

    response = []
    
    filter_by = params[:filter_by] || "user"

    if filter_by == "user"

      timesheet_by_users = all_timesheets.group_by{|t| t.user}

      all_project_users.each do |user|
        user_hash = user.as_json
        user_hash[:facilities] = []
        timesheets = timesheet_by_users[user] || []
        timesheet_task_ids = timesheets.map(&:resource_id).uniq
        t_facility_projects = timesheets.map(&:facility_project).uniq
        fp_array = []
        
        timesheet_by_tasks = timesheets.group_by{|t| t.resource }
        tasks = timesheet_by_tasks.keys
        tasks_by_facility_project = tasks.group_by{|task, timesheets| task.facility_project_id }
  
        t_facility_projects.each do |fp|
          tasks = tasks_by_facility_project[fp.id] || []
          fp_hash = fp.facility.attributes
          fp_hash[:facility_project_id] = fp.id
          fp_hash[:tasks] = []
          tasks.each do |task|
            fp_hash[:tasks] << task.timesheet_json( { timesheets: timesheet_by_tasks[task] })
          end
          
          fp_array << fp_hash
        end
        user_hash[:facilities] = fp_array
  
        response << user_hash
  
      end

    elsif filter_by == "project"
      all_tasks = Task.includes({facility_project: :facility}, notes: [:user]).where(id: all_timesheets.pluck(:resource_id).uniq )
      timesheet_by_task_id = all_timesheets.group_by{|t| t.resource_id }
      fps_tasks = all_tasks.group_by{|t| t.facility_project }

      fps_tasks.each do |fp, tasks|
        fp_hash = fp.facility.attributes
        fp_hash[:facility_project_id] = fp.id
        fp_hash[:tasks] = []
        tasks.each do |task|
          fp_hash[:tasks] << task.timesheet_json( { timesheets: timesheet_by_task_id[task.id] })
        end
        
        response << fp_hash
      end
    end

    # render json: {timesheets: response, total_pages: total_pages, current_page: current_page, next_page: next_page }
    render json: {timesheets: response }
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
