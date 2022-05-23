class Api::V1::ContractProjectDataController < AuthenticatedController

  def index
    contract_project_data = ContractProjectDatum.all.map(&:to_json)
    render json: {contract_project_data: contract_project_data}
  end

  def create
    contract_project_data = ContractProjectDatum.new.create_or_update_contract_project_data(params, current_user)
    if !contract_project_data.errors.any?
      render json: {contract_project_data: contract_project_data}
    else
      render json: {errors: contract_project_data.errors.full_messages}, status: 406
    end
  end

  def update
    contract_project_data = ContractProjectDatum.new.create_or_update_contract_project_data(params, current_user)
    if !contract_project_data.errors.any?
        render json: {contract_project_data: contract_project_data}
    else
      render json: {errors: contract_project_data.errors.full_messages}, status: 406
    end
  end

end