class Api::V1::FacilityGroupsController < AuthenticatedController
  # before_action :check_permission, only: [:move_to_program]

  def check_permission
    source_program_id = params[:source_program_id]
    target_program_id = params[:target_program_id]
    raise(CanCan::AccessDenied) if !source_program_id || !target_program_id || !current_user.is_program_admin?(source_program_id) || !current_user.is_program_admin?(target_program_id)
  end

  def index
    # authorized_program_ids = current_user.authorized_programs.pluck(:id)
    # all_facility_groups = []
    # if params[:project_id].present? && authorized_program_ids.include?(params[:project_id].to_i)
    #   facility_ids = FacilityProject.where(project_id: params[:project_id]).map(&:facility_id).compact.uniq
    #   all_facility_groups = FacilityGroup.where(facility_id: facility_ids)
    # else
    #   all_facility_groups = FacilityGroup.where(project_id: authorized_program_ids )
    # end
    response_hash = {}
    all_facility_groups = FacilityGroup.all.as_json
    response_hash = {facility_groups: all_facility_groups.as_json}
    if params[:program_id]
      project = Project.find(params[:program_id])
      response_hash[:program_group_ids] = project.project_groups.pluck(:id)
    end
    render json: response_hash
  end

  def create
    facility_group = FacilityGroup.new(facility_group_params)
    facility_group.status = :active
    facility_group.is_portfolio = false
    facility_group.user_id = current_user.id
    
    if facility_group.save
      if params[:facility_group][:project_id]
        project = Project.find( params[:facility_group][:project_id])
        project.project_groups << facility_group
      end
      render json: facility_group
    else
      render json: {errors: facility_group.errors.full_messages}, status: 406
    end
  end

  def bulk_project_update
    project = Project.find(params[:program_id])
    groups = FacilityGroup.where(id: params[:facility_group_ids])
    project.project_groups = groups
    render json: groups
  end

  def move_to_program
    source_program = Project.find(params[:source_program_id])
    target_program = Project.find(params[:target_program_id])

    all_facility_projects = FacilityProject.where(project_id: source_program.id, facility_group_id: params[:facility_group_id])
    failed_facility_projects = []
    all_facility_projects.each do |fp|
      result = fp.move_to_program(target_program.id, params[:target_facility_group_id])
      if !result[:status]
        failed_facility_projects << fp
      end 
    end
    
    # self.update(project_id: target_program_id)

    # project_facility_group = ProjectFacilityGroup.where(project_id: source_project.id, facility_group_id: params[:id]).first
    # project_facility_group.move_to_program(target_program_id)
    if failed_facility_projects.any?
      render json: {message: "Fail to move all projects from given group"}, status: 406
    else
      render json: {message: "Facility group projects are moved to program"}, status: 200
    end
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
    program = Project.find(params[:program_id])
    
    if program.project_groups.include?(group)
      if !group.is_portfolio? && !group.is_default?
        group.apply_unassigned_to_resource(program)
        if group.destroy
          render json: {message: "Group removed successfully"}, status: 200
        else
          render json: {errors: group.errors.full_messages}, status: 406
        end
      else
        program.project_facility_groups.where(facility_group_id: group.id ).destroy_all
        group.apply_unassigned_to_resource(program)
        render json: {message: "Group removed successfully"}, status: 200
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
