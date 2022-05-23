class Api::V1::ContractProjectPocsController < AuthenticatedController
  def index
    contract_project_pocs = 
    render json: {contract_project_pocs: ContractProjectPoc.all}
  end

  def create
    contract_project_poc = ContractProjectPoc.new(contract_project_poc_params)
    if contract_project_poc.save
      render json: {contract_project_poc: contract_project_poc}
    else
      render json: {errors: contract_project_poc.errors.full_message}, status: 406
    end
  end

  def update
    contract_project_poc = ContractProjectPoc.find(params[:id])
    if contract_project_poc.update(contract_project_poc_params)
      render json: {contract_project_poc: contract_project_poc}
    else
      render json: {errors: contract_project_poc.errors.full_message}, status: 406
    end
  end
  
  private
  def contract_project_poc_params
    params.require(:contract_project_poc).permit(:name, :poc_type, :email, :title, :work_number, :mobile_number, :notes)
  end

end