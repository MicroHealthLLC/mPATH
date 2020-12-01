class Api::FacilityGroupsController < AuthenticatedController
  def index
    tasks_hash = {
      tasks: [{task_files_attachments: :blob}, :task_type, :users, :task_stage, :checklists, :notes, :related_tasks, :related_issues, :sub_tasks, :sub_issues, {facility_project: :facility} ]
    }
    issues_hash = {
      issues: [{issue_files_attachments: :blob}, :issue_type, :users, :issue_stage, :checklists, :notes, :related_tasks, :related_issues, :sub_tasks, :sub_issues, {facility_project: :facility}, :issue_severity ]
    }
    notes_hash = {
      notes: [{note_files_attachments: :blob}, :user]
    }
    include_hash = {
      facility_projects: [:facility, tasks_hash, issues_hash, notes_hash]
    }

    if params[:project_id].present?
      collection = FacilityGroup.includes(include_hash).joins(:facility_projects).where("facility_projects.project_id = ?", params[:project_id]).distinct
    else
      collection = FacilityGroup.includes(include_hash).all
    end

    render json: {facility_groups: collection.as_json}
  end
end
