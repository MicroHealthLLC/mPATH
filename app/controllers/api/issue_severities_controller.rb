class Api::IssueSeveritiesController < AuthenticatedController

  def index
    render json: {Issue_severities: IssueSeverity.all.as_json}
  end
end
