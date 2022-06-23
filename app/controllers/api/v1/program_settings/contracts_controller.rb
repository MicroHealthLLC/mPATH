class Api::V1::ProgramSettings::ContractsController < AuthenticatedController 
  before_action :check_permission

  def check_permission
    program_id = params[:project_id]

    raise(CanCan::AccessDenied) if !program_id
    action = nil

    if ["index", "show" ].include?(params[:action]) 
      action = "R"
    elsif ["create", "update"].include?(params[:action]) 
      action = "W"
    elsif ["destroy"].include?(params[:action]) 
      action = "D"
    end

    raise(CanCan::AccessDenied) if !current_user.has_program_setting_role?(program_id, action, RolePrivilege::PROGRAM_SETTING_CONTRACTS)
  end

  def index

    project_contracts = ProjectContract.includes(:contract_project_datum, :facility_group).where(project_id: params[:project_id])
    c = []
    project_contracts.in_batches do |_project_contracts|
      c += _project_contracts.map{|pc| pc.contract_project_datum.to_json({project_contract: pc}) }
    end
    render json: {contracts: c, total_count: c.size}
  end

  def show
    project_contract = ProjectContract.where(id: params[:id],project_id: params[:project_id]).first
    if project_contract
      render json: {contract: project_contract.contract_project_datum.to_json({project_contract: project_contract}), message: "Successfully updated contract "}
    else
      render json: {error: "Error updating contract!"}, staus: 406
    end
  end
  
  def update
    project_contract = ProjectContract.where(id: params[:id],project_id: params[:project_id]).first
    if project_contract && project_contract.update(project_contract_params)
      render json: {message: "Successfully updated contract "}
    else
      render json: {error: "Error updating contract!"}, staus: 406
    end
  end

  def destroy
    project_contract = ProjectContract.where(id: params[:id], project_id: params[:project_id]).first

    if project_contract && project_contract.destroy
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