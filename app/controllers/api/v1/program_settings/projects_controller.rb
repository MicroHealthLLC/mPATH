class Api::V1::ProgramSettings::ProjectsController < AuthenticatedController 

  # before_action :check_permission

  def check_permission
    program_id = params[:project_id]

    raise(CanCan::AccessDenied) if !program_id
    action = nil
    if ["index", "show","task_issues" ].include?(params[:action]) 
      action = "R"
    elsif ["create", "update", "add_users"].include?(params[:action]) 
      action = "W"
    elsif ["destroy", "remove_role"].include?(params[:action]) 
      action = "D"
    end

    raise(CanCan::AccessDenied) if !current_user.has_program_setting_role?(program_id,action,  RolePrivilege::PROGRAM_SETTING_USERS_ROLES)
  end

  def show
    @project = current_user.authorized_programs.find_by(id: params[:id])
    unless @project.nil?
    render json: {project: @project.build_json_response_for_program_settings(current_user)}, status: 200
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
    @project = Project.includes(projects_include_hash).find_by(id: params[:id])
  end

end
