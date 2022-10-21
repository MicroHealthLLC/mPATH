class ContractProjectPocResource < ApplicationRecord
  belongs_to :resource, polymorphic: true
  belongs_to :contract_project_poc
  validates :contract_project_poc_id, uniqueness: { scope: [ :resource_id, :resource_type, :poc_type ], message: "Can't add same contract POC multiple times."  }
end
