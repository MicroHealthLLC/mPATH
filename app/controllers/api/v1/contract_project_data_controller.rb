class Api::V1::ContractProjectDataController < AuthenticatedController

  def index
    contract_project_data = ContractProjectDatum.all.map(&:to_json)
    render json: {contract_project_data: contract_project_data}
  end

  def create
    contract_project_data = ContractProjectDatum.new.create_or_update_contract_project_data(contract_project_data_params, current_user)
    if contract_project_data.errors.any?
        render json: {contract_project_data: contract_project_data}
    else
      render json: {errors: contract_project_data.errors.full_message}, status: 406
    end
  end

  def update
    contract_project_data = ContractProjectDatum.new.create_or_update_contract_project_data(contract_project_data_params, current_user)
    if contract_project_data.errors.any?
        render json: {contract_project_data: contract_project_data}
    else
      render json: {errors: contract_project_data.errors.full_message}, status: 406
    end
  end
    
  private
  def contract_project_data_params
    params.require(:contract_project_data).permit(
      :name, 
      :charge_code, 
      :contract_customer_id, 
      :prime_or_sub, 
      :contract_start_date, 
      :contract_end_date, 
      :total_contract_value, 
      :contract_current_pop_start_date, 
      :contract_current_pop_end_date
    )
    # params.require(:contract_project_data).permit(:name, :charge_code, :contract_customer_id, :contract_award_to_id, :contract_type_id, :prime_or_sub, :contract_start_date, :contract_end_date, :total_contract_value, :contract_pops, :contract_current_pop_id, :contract_current_pop_start_date, :contract_current_pop_end_date, :total_founded_value, :billings_to_date, :comments, :pm_contract_poc_id, :gov_contract_poc_id, :co_contract_poc_id, :contract_naic_id)
  end
end