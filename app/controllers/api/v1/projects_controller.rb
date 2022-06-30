class Api::V1::ProjectsController < AuthenticatedController 
# class Api::V1::ProjectsController < Api::ApplicationController
  before_action :set_project, only: [:destroy, :update, :gantt_chart, :watch_view, :member_list, :facility_manager, :sheet, :calendar]
  # before_action :authenticate_request!

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
      render json: {project: @project.build_json_response(current_user, response_for: 'client_panel')}, status: 200
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
