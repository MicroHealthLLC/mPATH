class Api::IssueTypesController < AuthenticatedController

  def index
    render json: {Issue_types: IssueType.all.as_json}
  end
end
