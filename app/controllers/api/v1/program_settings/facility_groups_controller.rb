class Api::V1::ProgramSettings::FacilityGroupsController < AuthenticatedController

  before_action :check_permission

  def check_permission
    program_id = params[:project_id]

    raise(CanCan::AccessDenied) if !program_id
    action = nil

    if ["index", "show" ].include?(params[:action]) 
      action = "R"
    elsif ["create", "update", "bulk_project_update"].include?(params[:action]) 
      action = "W"
    elsif ["destroy"].include?(params[:action]) 
      action = "D"
    end    

    raise(CanCan::AccessDenied) if !current_user.has_program_setting_role?(program_id,action,  RolePrivilege::PROGRAM_SETTING_GROUPS)
  end

  def index
    response_hash = {}
    all_facility_groups = FacilityGroup.includes(:project_facility_groups).all.as_json
    response_hash = {facility_groups: all_facility_groups}
    if params[:project_id]
      project = Project.find(params[:project_id])
      response_hash[:program_group_ids] = project.project_groups.pluck(:id)
    end
    render json: response_hash
  end

  def create
    facility_group = FacilityGroup.new(facility_group_params)
    facility_group.status = :active
    facility_group.user_id = current_user.id
    project = Project.find(params[:project_id])
    facility_group.owner_id = project.id
    facility_group.owner_type = project.class.name
    
    if facility_group.save
      if project
        project.project_groups << facility_group
      end
      render json: facility_group
    else
      render json: {errors: facility_group.errors.full_messages}, status: 406
    end
  end

  def bulk_project_update
    project = Project.find(params[:project_id])
    groups = FacilityGroup.where(id: params[:facility_group_ids])
    project.project_groups = groups
    render json: groups
  end

  def update
    group = FacilityGroup.find(params[:id])
    
    if group.update(facility_group_params)
      render json: group
    else
      render json: {errors: "Error while updating groups"}, status: 406
    end
  end

  def destroy
    group = FacilityGroup.find(params[:id])
    program = Project.find(params[:project_id])
    
    if program.project_groups.include?(group)
      project_facility_group = program.project_facility_groups.find_by(facility_group_id: group.id)
      if !group.is_portfolio? && !project_facility_group.is_default?
        project_facility_group.apply_unassigned_to_resource
        if group.destroy
          render json: {message: "Group removed successfully"}, status: 200
        else
          render json: {errors: group.errors.full_messages}, status: 406
        end
      elsif group.is_portfolio? && !project_facility_group.is_default?
        if project_facility_group.apply_unassigned_to_resource
          project_facility_group.destroy
          render json: {message: "Group removed successfully"}, status: 200
        else
          render json: {message: "Error removing group"}, status: 406
        end
      else
        render json: {message: "Can't remove deafult group!"}, status: 406
      end
    else
      render json: {errors: "Group is not part of current program!"}, status: 406
    end
  end

  def include_hash
    {
      facility_projects: [:facility, {
        tasks: [{task_files_attachments: :blob}, :task_type, :users, :task_stage, :checklists, :notes, :related_tasks, :related_issues, :sub_tasks, :sub_issues, {facility_project: :facility} ]
        }, {
        issues: [{issue_files_attachments: :blob}, :issue_type, :users, :issue_stage, :checklists, :notes, :related_tasks, :related_issues, :sub_tasks, :sub_issues, {facility_project: :facility}, :issue_severity ]
        }, {
          notes: [{note_files_attachments: :blob}, :user]
        }
      ]
    }
  end

  private

  def facility_group_params
    params.require(:facility_group).permit(
      :name
    )
  end
end
