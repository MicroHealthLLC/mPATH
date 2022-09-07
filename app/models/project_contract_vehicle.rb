class ProjectContractVehicle < ApplicationRecord
  belongs_to :contract_vehicle
  belongs_to :project
  belongs_to :contract_vehicle_project, class_name: "Project", foreign_key: :project_id
  belongs_to :contract_vehicle_facility_group, class_name: "FacilityGroup", foreign_key: :facility_group_id, optional: true
  belongs_to :facility_group, optional: true
  validates :project_id, uniqueness: { scope: [ :contract_vehicle_id ], message: "Can't add same contract vehicle multiple times in same program."  }

  has_many :tasks, dependent: :destroy
  has_many :issues, dependent: :destroy
  has_many :risks, dependent: :destroy
  has_many :lessons, dependent: :destroy
  has_many :notes, as: :noteable, dependent: :destroy

  before_create :assign_default_facility_group 
  before_update :assign_default_facility_group 

  def to_json(options: {})
    h = self.as_json
    h.merge!({project_contract_vehicle_id: self.id})
    h.merge!({contract_vehicle: contract_vehicle.to_json})
    h.merge!({facility_group: facility_group.as_json })
    h
  end

  def assign_default_facility_group
    if self.facility_group.nil?
      self.facility_group_id = project.default_facility_group.id
    end
  end
end
