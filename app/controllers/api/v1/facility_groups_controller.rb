class Api::V1::FacilityGroupsController < AuthenticatedController

  def index
    # authorized_program_ids = current_user.authorized_programs.pluck(:id)
    # all_facility_groups = []
    # if params[:project_id].present? && authorized_program_ids.include?(params[:project_id].to_i)
    #   facility_ids = FacilityProject.where(project_id: params[:project_id]).map(&:facility_id).compact.uniq
    #   all_facility_groups = FacilityGroup.where(facility_id: facility_ids)
    # else
    #   all_facility_groups = FacilityGroup.where(project_id: authorized_program_ids )
    # end
    all_facility_groups = FacilityGroup.all.as_json
    render json: {facility_groups: all_facility_groups.as_json}
  end

  def create
    facility_group = FacilityGroup.new(facility_group_params)
    facility_group.status = :active
    if facility_group.save
      render json: facility_group
    else
      render json: {errors: facility_group.errors.full_messages}, status: 406
    end
  end

  def bulk_update
    project = Project.find(params[:project_id])
    groups = FacilityGroup.where(id: params[:facility_group_ids])
    if groups.update_all(project_id: project.id)
      render json: groups
    else
      render json: {errors: "Error while updating groups"}, status: 406
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
      :name,
      :project_id
    )
  end
end
