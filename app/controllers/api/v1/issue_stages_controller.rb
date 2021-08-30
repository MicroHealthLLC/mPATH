class Api::V1::IssueStagesController < AuthenticatedController
  def index
    render json: {issue_stages: IssueStage.all.as_json}
  end
end
