class Api::V1::Admin::IssueStagesController < AuthenticatedController
  def index
    render json: {issue_stages: IssueStage.all.as_json}
  end
end
