class Contract < ApplicationRecord
  belongs_to :contract_type
  belongs_to :contract_status
  belongs_to :contract_name_customer
  belongs_to :contract_vehicle
  belongs_to :contract_vehicle_number
  belongs_to :contract_number
  belongs_to :subcontract_number
  belongs_to :contract_prime
  belongs_to :contract_current_pop

  def self.params_to_permit
    [
      :id,
      :contract_type_id,
      :project_code,
      :contract_nickname,
      :contract_status_id,
      :contract_name_customer_id,
      :contract_vehicle_id,
      :contract_vehicle_number_id,
      :contract_number_id, 
      :contract_classification_id, 
      :subcontract_number_id, 
      :contract_prime_id, 
      :start_date,
      :end_date,
      :contract_current_pop_id, 
      :current_pop_start_time,
      :current_pop_end_time,
      :days_remaining,
      :total_contract_value,
      :current_pop_value,
      :current_pop_funded,
      :total_contract_funded
    ]
  end

  def create_or_update_issue(params, user)
    contract_params = params.require(:contract).permit(Contract.params_to_permit)
    c_params = contract_params.dup
    if c_params[:id]
      contract = Contract.find(c_params[:id])
    else
      contract = self
    end    
    contract.attributes = c_params
    contract.user_id = user.id
    contract.save
    contract
  end

end
