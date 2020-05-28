class Api::IssueStatusesController < AuthenticatedController

  def index
    render json: {issue_statuses: IssueStatus.all.as_json}
  end
end
