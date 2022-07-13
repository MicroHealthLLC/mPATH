class Api::V1::ProgramSettings::ProjectsController < AuthenticatedController 

  before_action :check_permission

  def check_permission
    program_id = params[:id]

    raise(CanCan::AccessDenied) if !program_id
    action = nil
    if ["show" ].include?(params[:action]) 
      action = "R"
    elsif ["add_contract" ].include?(params[:action]) 
        action = "W"
    end

    raise(CanCan::AccessDenied) if !current_user.has_program_setting_role?(program_id,action,  RolePrivilege::PROGRAM_SETTINGS_ROLE_TYPES)
  end

  def show
    @project = current_user.authorized_programs.find_by(id: params[:id])
    unless @project.nil?
    render json: {project: @project.build_json_response(current_user, response_for: 'program_settings')}, status: 200
     else
      render json: {error: "Project not found"}, status: :not_found
    end
  end

  def add_contract
    contract_project_data = ContractProjectDatum.find(params[:contract_id])
    project = Project.find(params[:id])
    project_contract = ProjectContract.new(project_id: project.id, contract_project_datum_id: contract_project_data.id)
    if project_contract.save
      render json: {message: "Contract added successfully"}
    else
      render json: {error: project_contract.errors.full_messages}, status: 406
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
  end

end
