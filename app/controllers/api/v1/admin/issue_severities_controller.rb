class Api::V1::Admin::IssueSeveritiesController < AuthenticatedController

  def index
    render json: {issue_severities: IssueSeverity.all.as_json}
  end
end
