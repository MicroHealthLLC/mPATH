class IssuesController < AuthenticatedController
  before_action :set_resources
  before_action :set_issue, only: [:show, :update, :destroy]

  def index
    render json: {issues: @facility_project.issues.map(&:to_json)}
  end

  def create
    @issue = Issue.new.create_or_update_issue(params, current_user)
    render json: {issue: @issue.reload.to_json}
  end

  def update
    destroy_files_first if destroy_file_ids.present?
    i_params = issue_params.dup
    if i_params[:checklists_attributes].present?
      i_params[:checklists_attributes].each do |key, hash|
        if hash["progress_lists_attributes"].present?
          hash["progress_lists_attributes"].each do |key2, hash2|
            hash2[:user_id] = current_user.id if hash2[:user_id].nil?
          end
        end
      end
    end
    @issue.update(i_params)
    @issue.assign_users(params)

    render json: {issue: @issue.reload.to_json}
  end

  def show
    render json: {issue: @issue.to_json}
  end

  def destroy
    @issue.destroy!
    render json: {}, status: 200
  rescue
    render json: {}, status: 500
  end

  def batch_update
    Issue.update(params[:issues].keys, params[:issues].values)
    render json: @facility_project.as_json
  end

  private
  def set_resources
    @project = current_user.projects.active.find_by(id: params[:project_id])
    @facility_project = @project.facility_projects.find_by(facility_id: params[:facility_id])
  end

  def set_issue
    @issue = @facility_project.issues.find_by(id: params[:id])
  end

  def issue_params
    params.require(:issue).permit(
      :title,
      :description,
      :issue_type_id,
      :issue_stage_id,
      :issue_severity_id,
      :facility_project_id,
      :progress,
      :start_date,
      :due_date,
      :auto_calculate,
      :watched,
      :task_type_id,
      :kanban_order,
      issue_files: [],
      user_ids: [],
      sub_task_ids: [],
      sub_issue_ids: [],
      sub_risk_ids: [],
      checklists_attributes: [
        :id,
        :_destroy,
        :text,
        :user_id,
        :checked,
        :position,
        :due_date,
        :position,
         progress_lists_attributes: [
          :id,
          :_destroy,
          :body,
          :checklist_id,
          :user_id
        ]
      ],
      notes_attributes: [
        :id,
        :_destroy,
        :user_id,
        :body
      ]
    )
  end

  def destroy_file_ids
    params[:issue][:destroy_file_ids]&.split(',')&.map(&:to_i)
  end

  def destroy_files_first
    @issue.issue_files.where(id: destroy_file_ids)&.map(&:purge)
  end
end
