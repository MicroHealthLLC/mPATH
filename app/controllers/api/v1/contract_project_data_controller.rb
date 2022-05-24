class Api::V1::ContractProjectDataController < AuthenticatedController

  def add_project
    contract_project_data = ContractProjectDatum.find(params[:id])
    project = Project.find(params[:project_id])
    project_contract = ProjectContract.new(project_id: project.id, contract_project_datum_id: contract_project_data.id)
    if project_contract.save
      render json: {message: "Contract added successfully"}
    else
      render json: {error: project_contract.errors.full_messages}, status: 406
    end
  end

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

  def destroy
    contract_project_data = ContractProjectDatum.find(params[:id])
    if contract_project_data.destroy
        render json: {contract_project_data: contract_project_data, message: "Contract Project Data deleted successfully!!"}
    else
      render json: {errors: contract_project_data.errors.full_messages}, status: 406
    end
  end
end