class IssuesController < AuthenticatedController
  before_action :set_resources
  before_action :set_issue, only: [:show, :update, :destroy, :destroy_file]

  def index
    render json: {issues: @facility_project.issues.map(&:to_json)}
  end

  def create
    @issue = @facility_project.issues.create(issue_params)
    render json: {issue: @issue.to_json}
  end

  def update
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

  def destroy_file
    file = @issue.issue_files.find_by(id: file_params[:id])
    file.purge if file.present?
    render json: {issue: @issue.to_json}
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
      issue_files: []
    )
  end

  def file_params
    params.require(:file).permit(:id, :uri)
  end
end
