class ContractProjectPocResource < ApplicationRecord
  belongs_to :resource, polymorphic: true
  belongs_to :contract_project_poc
end
