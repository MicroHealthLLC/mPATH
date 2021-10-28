class Api::V1::ContractsController < AuthenticatedController

  def index
    all_contracts = Contract.all
    render json: {contracts: all_countract}
  end
end
