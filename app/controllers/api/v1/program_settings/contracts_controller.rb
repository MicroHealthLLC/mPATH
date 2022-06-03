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
    project_contarct = ProjectContract.where(id: params[:id],project_id: params[:project_id]).first
    if project_contarct
      render json: {contract: project_contarct.contract_project_datum.to_json({project_contract_id: params[:id]}), message: "Successfully updated contract "}
    else
      render json: {error: "Error updating contract!"}, staus: 406
    end
  end
  
  def update
    project_contarct = ProjectContract.where(id: params[:id],project_id: params[:project_id]).first
    if project_contarct && project_contarct.update(project_contract_params)
      render json: {message: "Successfully updated contract "}
    else
      render json: {error: "Error updating contract!"}, staus: 406
    end
  end

  def destroy
    project_contarct = ProjectContract.where(id: params[:id], project_id: params[:project_id]).first

    if project_contarct && project_contarct.destroy
      render json: {message: "Successfully removed association!"}
    else
      render json: {error: "Error removing association!"}, staus: 406
    end
  end

  private
  def project_contract_params
    params.require(:project_contract).permit(:facility_group_id)
  end

end