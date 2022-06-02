class Api::V1::ProgramSettings::ContractsController < AuthenticatedController 
  before_action :check_program_admin

  def index

    project_contracts = ProjectContract.includes(:contract_project_datum).where(project_id: params[:project_id])
    c = []
    project_contracts.in_batches do |_project_contracts|
      c += _project_contracts.map{|pc| pc.contract_project_datum.to_json({project_contract_id: pc.id}) }
    end
    render json: {contracts: c, total_count: c.size}
  end

  def show
    render json: {contract: ProjectContract.find(params[:id]).contract_project_datum.to_json({project_contract_id: params[:id]})}
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