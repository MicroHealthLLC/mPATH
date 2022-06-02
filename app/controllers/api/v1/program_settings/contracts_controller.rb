class Api::V1::ProgramSettings::ContractsController < AuthenticatedController 
  before_action :check_program_admin

  def index
    contract_project_data_ids = ProjectContract.where(project_id: params[:project_id]).pluck(:contract_project_datum_id).compact.uniq
    contract_project_datas = ContractProjectDatum.where(id: contract_project_data_ids )
    c = []
    contract_project_datas.in_batches do |contract_project_data|
      c << contract_project_data.map(&:to_json)
    end if contract_project_datas.any?
    render json: {contracts: c, total_count: c.size}

  end

  def show
    render json: {contract: ProjectContract.find(params[:id]).contract_project_datum.to_json}
  end

  def destroy
    project_contarct = ProjectContract.find(params[:id])
    if project_contarct.destroy
      render json: {message: "Successfully removed association!"}
    else
      render json: {error: "Error removing association!"}
    end
  end

end