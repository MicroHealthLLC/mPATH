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
end
