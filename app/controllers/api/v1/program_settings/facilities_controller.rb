class Api::V1::ProgramSettings::FacilitiesController < AuthenticatedController
  
  # before_action :check_program_admin
  before_action :set_project
  before_action :set_facility, only: [:show]

  before_action :check_permission

  def check_permission
    program_id = params[:project_id]

    raise(CanCan::AccessDenied) if !program_id
    action = nil

    if ["index", "show" ].include?(params[:action]) 
      action = "R"
    elsif ["create", "update", "bulk_projects_update"].include?(params[:action]) 
      action = "W"
    elsif ["destroy", "remove_facility_project"].include?(params[:action]) 
      action = "D"
    end

    raise(CanCan::AccessDenied) if !current_user.has_program_setting_role?(program_id, action,  RolePrivilege::PROGRAM_SETTING_PROJECTS)
  end

  def index
    response_hash = {}
    if params[:project_id]
      project = Project.find(params[:project_id])
      response_hash[project.id] = {facility_ids: project.facility_ids}
    end
    if ActiveModel::Type::Boolean.new.cast(params[:all]) 
      projects = current_user.projects
      projects.each do |_project|
        response_hash[_project.id] = {facility_ids: _project.facility_ids}
      end
    end

    all_facilities = Facility.includes(:facility_group).all.as_json
    response_hash[:facilities] = all_facilities.as_json

    render json: response_hash
  end

  def create
    @facility = @project.facilities.create(facility_params.merge({creator: current_user, is_portfolio: false}))
    if params[:facility][:facility_group_id]
      @project.facility_projects.where(facility_id: @facility.id).first&.update(facility_group_id: params[:facility][:facility_group_id] )
    end
    render json: {facility: @facility.as_json}
  end

  def show
    render json: {facility: @facility_project.as_json}
  end

  # Juan's  bulk_projects_update 
  def bulk_projects_update
    # logic for adding projects to current program
    project = Project.find(params[:project_id])
    facility_ids = ( project.facility_ids + params[:facility_ids].map(&:to_i) ).compact.uniq
    project.facility_ids = facility_ids if facility_ids.any?
    render json: Facility.where(id: facility_ids)
  end

  def remove_facility_project
    @facility_project = FacilityProject.find(params[:facility_project_id])
    if @facility_project.destroy
      render json:  @facility_project
    else
      render json: {errors: @facility_project.errors.full_messages }, status: 406  
    end      
  end

  def update
    # @facility_project.update(facility_project_params)
    @facility = Facility.find(params[:id])
    if params[:facility].present?
      if(params[:facility][:facility_group_name] && params[:facility][:facility_group_name] != 'undfined')
        @facility.facility_group.update(name: params[:facility][:facility_group_name])
      end
      @facility.update(facility_params)
    end
    @facility_project = @facility.facility_projects.find_by(project_id: params[:project_id])
    @facility_project&.update(status_id: params[:status_id], due_date: params[:due_date], facility_group_id: params[:facility][:facility_group_id])
    render json: {facility: @facility.as_json}
  end

  def destroy
    @facility = @project.facilities.find_by(id: params[:id])
    @facility.destroy!
    render json: {}, status: 200
  rescue
    render json: {}, status: :not_found
  end

  private
  def set_facility
    @facility_project = @project.facility_projects.includes(include_hash, :status).find_by(facility_id: params[:id])
  end

  def set_project
    @project = current_user.authorized_programs.find_by(id: params[:project_id])
  end

  def facility_params
    params.require(:facility).permit(
      :country_code,
      :project_id,
      :facility_name,
      :address,
      :facility_group_id,
      :point_of_contact,
      :phone_number,
      :email,
      :lat,
      :lng
    )
  end

  def facility_project_params
    params.require(:facility).permit(
      :status_id,
      :due_date
    )
  end

  def include_hash
    {
      facility: [:facility_group],
      risks: [{risk_files_attachments: :blob}, :user, :checklists, :related_tasks, :related_issues,:related_risks, :sub_tasks, :sub_issues, {facility_project: :facility} ],
      tasks: [{task_files_attachments: :blob}, :task_type, :users, :task_stage, :checklists, :notes, :related_tasks, :related_issues, :sub_tasks, :sub_issues, {facility_project: :facility} ],
      issues: [{issue_files_attachments: :blob}, :issue_type, :users, :issue_stage, :checklists, :notes, :related_tasks, :related_issues, :sub_tasks, :sub_issues, {facility_project: :facility}, :issue_severity ],
      notes: [{note_files_attachments: :blob}, :user]
    }
  end
end
