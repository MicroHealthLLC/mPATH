class ProjectContract < ApplicationRecord
  belongs_to :contract_project_datum
  belongs_to :project
  belongs_to :contract_project, class_name: "Project", foreign_key: :project_id
  belongs_to :contract_facility_group, class_name: "FacilityGroup", foreign_key: :facility_group_id, optional: true
  belongs_to :facility_group, optional: true
  validates :project_id, uniqueness: { scope: [ :contract_project_datum_id ], message: "Can't add same contract multiple times in same program."  }

  has_many :tasks, dependent: :destroy
  has_many :issues, dependent: :destroy
  has_many :risks, dependent: :destroy
  has_many :lessons, dependent: :destroy
  has_many :notes, as: :noteable, dependent: :destroy

  before_create :assign_default_facility_group 
  before_update :assign_default_facility_group 
  after_destroy :remove_roles

  def to_json(options = {})
    h = contract_project_datum.to_json
    h.merge!({project_contract_id: id })
    h.merge!({facility_group: facility_group.as_json })
    h.merge!({facility_group_id: facility_group_id })
    h.merge!({contract_customer: contract_project_datum.contract_customer.as_json})
    h.merge!({contract_vehicle: contract_project_datum.contract_vehicle.to_json})
    h.merge!({contract_award_to: contract_project_datum.contract_award_to.as_json})
    h.merge!({contract_pop: contract_project_datum.contract_pop.as_json})
    h.merge!({contract_naic: contract_project_datum.contract_naic.as_json})
    h.merge!({contract_award_type: contract_project_datum.contract_award_type.as_json})
    h.merge!({contract_type: contract_project_datum.contract_type.as_json})
    h.merge!({contract_current_pop: contract_project_datum.contract_current_pop.as_json})
    h.merge!({contract_number: contract_project_datum.contract_number.as_json})
    h
  end

  def remove_roles
    RoleUser.where(project_contract_id: self.id).destroy_all
  end

  def assign_default_facility_group
    if self.facility_group.nil?
      self.facility_group_id = project.default_facility_group.id
    end
  end

  def update_progress
    t = tasks
    p = 0
    if t.any?
      p = (t.map(&:progress).sum / t.size).round(0)
    end
    self.update(progress: p)
  end

end
