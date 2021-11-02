class Api::V1::Admin::IssueTypesController < AuthenticatedController

  def index
    render json: {issue_types: IssueType.all.as_json}
  end
end
