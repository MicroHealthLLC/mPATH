class Api::V1::ContractsController < AuthenticatedController

  def index
    all_contracts = Contract.all
    render json: {contracts: all_contracts}
  end

  def create
    @contract = Contract.new.create_or_update_issue(params, current_user)
    if @contract.errors.any?
      render json: {errors: @contract.errors.full_messages}, status: 406
    else
      render json: {contract: @contract.reload.as_json}
    end
  end

  def update
    @contract = Contract.new.create_or_update_issue(params, current_user)
    if @contract.errors.any?
      render json: {errors: @contract.errors.full_messages}, status: 406
    else
      render json: {contract: @contract.reload.as_json}
    end
  end

  def destroy
    @contract = Contract.find(params[:id])
    if @contract.destroy
      render json: {contract: @contract.as_json}
    end
  end

end
