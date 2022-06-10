class ContractNumber < ApplicationRecord
  has_many :contract_project_datum
  validates_presence_of :name
end
