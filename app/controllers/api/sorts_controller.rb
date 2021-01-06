class Api::SortsController < AuthenticatedController
  before_action :require_admin

  def update
    @model = Sort.find_or_create_by(relation: sort_params[:relation])
    @model.update(sort_params)
    render json: @model, status: 200
  rescue
    render json: {}, status: 500
  end

  private
  def sort_params
    params.permit(
      :relation,
      :column,
      :order
    )
  end
end
