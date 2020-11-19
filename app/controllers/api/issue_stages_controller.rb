class Api::IssueStagesController < AuthenticatedController
  def index
    render json: {issue_stages: IssueStage.all.as_json}
  end
end
