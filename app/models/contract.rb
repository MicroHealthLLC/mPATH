class Contract < ApplicationRecord
  belongs_to :contract_type
  belongs_to :contract_status, optional: true
  belongs_to :contract_name_customer, optional: true
  belongs_to :contract_vehicle, optional: true
  belongs_to :contract_vehicle_number, optional: true
  belongs_to :contract_number, optional: true
  belongs_to :subcontract_number, optional: true
  belongs_to :contract_prime, optional: true
  belongs_to :contract_current_pop, optional: true
  belongs_to :contract_classification, optional: true
  belongs_to :facility_group, optional: true
  belongs_to :project, optional: true

  validates_presence_of :contract_type_id, :contract_nickname

  # validates_presence_of :contract_type_id, :contract_status_id, :contract_name_customer_id, :contract_vehicle_id, :contract_vehicle_number_id, :contract_number_id, :subcontract_number_id, :contract_prime_id, :contract_current_pop_id,:project_code, :contract_nickname, :contract_classification_id, :current_pop_start_time, :current_pop_end_time, :days_remaining, :total_contract_value, :current_pop_value, :current_pop_funded, :total_contract_funded, :start_date, :end_date

  def to_json
    # self.as_json(except: [:created_at, :updated_at, :contract_type_id, :contract_status_id, :contract_name_customer_id, :contract_vehicle_id, :contract_vehicle_number_id, :contract_number_id, :subcontract_number_id, :contract_prime_id, :contract_current_pop_id, :contract_classification_id]).merge(
    #   class_name: self.class.name,
    #   contract_status: contract_status.as_json(except: [:created_at, :updated_at]),
    #   contract_name_customer: contract_name_customer.as_json(except: [:created_at, :updated_at]),
    #   contract_vehicle: contract_vehicle.as_json(except: [:created_at, :updated_at]),
    #   contract_vehicle_number: contract_vehicle_number.as_json(except: [:created_at, :updated_at]),
    #   contract_number: contract_number.as_json(except: [:created_at, :updated_at]),
    #   subcontract_number: subcontract_number.as_json(except: [:created_at, :updated_at]),
    #   contract_prime: contract_prime.as_json(except: [:created_at, :updated_at]),
    #   contract_current_pop: contract_current_pop.as_json(except: [:created_at, :updated_at]),
    #   contract_classification: contract_classification.as_json(except: [:created_at, :updated_at])
    # ).as_json
    self.as_json(except: [:created_at, :updated_at]).merge(facility_group_name: facility_group.name)
  end

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
      :total_contract_funded,
      :facility_group_id,
      :project_id
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
