class Api::V1::FacilityGroupsController < AuthenticatedController

  def index
    if params[:project_id].present?
      facility_ids = FacilityProject.where(project_id: params[:project_id]).map(&:facility_id).compact.uniq
      collection = FacilityGroup.includes(include_hash).where(facility_id: facility_ids)
    else
      collection = FacilityGroup.includes(include_hash).all
    end

    render json: {facility_groups: collection.as_json}
  end

  def create
    facility_group = FacilityGroup.new(facility_group_params)
    if facility_group.save
      render json: facility_group
    else
      render json: {errors: facility_group.errors.full_messages}, status: 406
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
