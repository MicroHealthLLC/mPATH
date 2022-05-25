class ContractVehicle < ApplicationRecord
  has_many :contracts
  belongs_to :contract_sub_category, optional: true
  belongs_to :contract_agency, optional: true
  validates_presence_of :name

  def to_json
    h = self.as_json
    h.merge!({contract_sub_category: contract_sub_category.as_json}) if contract_sub_category
    h.merge!({contract_agency: contract_agency.as_json}) if contract_agency_id
    h.merge!({vehicle_type: vehicle_type.as_json}) if vehicle_type_id
    h
  end
end
