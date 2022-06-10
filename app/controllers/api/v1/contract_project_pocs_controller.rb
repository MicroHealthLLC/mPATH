class Api::V1::ContractProjectPocsController < AuthenticatedController
  before_action :check_contract_read_permission, only: [:index]
  before_action :check_contract_write_permission, only: [:create, :update, :add_project]
  before_action :check_contract_delete_permission, only: [:destroy]
  
  def check_contract_read_permission
    raise CanCan::AccessDenied if !current_user.can_read_contract_data?
  end
  def check_contract_write_permission
    raise CanCan::AccessDenied if !current_user.can_write_contract_data?
  end
  def check_contract_delete_permission
    raise CanCan::AccessDenied if !current_user.can_delete_contract_data?
  end
   
  def index
    render json: {contract_project_pocs: ContractProjectPoc.all}
  end

  def create
    contract_project_poc = ContractProjectPoc.new(contract_project_poc_params)
    contract_project_poc.user_id = current_user.id
    if contract_project_poc.save
      render json: {contract_project_poc: contract_project_poc}
    else
      render json: {errors: contract_project_poc.errors.full_messages}, status: 406
    end
  end

  def update
    contract_project_poc = ContractProjectPoc.find(params[:id])
    if contract_project_poc.update(contract_project_poc_params)
      render json: {contract_project_poc: contract_project_poc}
    else
      render json: {errors: contract_project_poc.errors.full_messages}, status: 406
    end
  end

  def destroy
    contract_project_poc = ContractProjectPoc.find(params[:id])
    if contract_project_poc.destroy
      render json: { message: "Contract Project POC deleted successfully!!", contract_project_poc: contract_project_poc}
    else
      render json: {errors: contract_project_poc.errors.full_messages}, status: 406
    end
  end
  
  private
  def contract_project_poc_params
    params.require(:contract_project_poc).permit(:name, :poc_type, :email, :title, :work_number, :mobile_number, :notes, :user_id)
  end

end