class ContractNumber < ApplicationRecord
  has_many :contract_project_datum
  has_many :contract_vehicles
  
  validates_presence_of :name
end
