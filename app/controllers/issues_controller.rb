class IssuesController < AuthenticatedController
  before_action :set_resources
  before_action :set_issue, only: [:show, :update, :destroy]

  def index
    render json: {issues: @facility_project.issues.map(&:to_json)}
  end

  def create
    @issue = @facility_project.issues.create(issue_params)
    render json: {issue: @issue.to_json}
  end

  def update
    destroy_files_first if destroy_file_ids.present?
    @issue.update(issue_params)
    render json: {issue: @issue.to_json}
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
      :issue_severity_id,
      :progress,
      :start_date,
      :due_date,
      :auto_calculate,
      :watched,
      issue_files: [],
      user_ids: [],
      checklists_attributes: [
        :id,
        :_destroy,
        :text,
        :user_id,
        :checked
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
