class ProjectContract < ApplicationRecord
  belongs_to :contract_project_datum
  belongs_to :project
  belongs_to :contract_project, class_name: "Project", foreign_key: :project_id
  belongs_to :contract_facility_group, class_name: "FacilityGroup", foreign_key: :facility_group_id, optional: true
  belongs_to :facility_group, optional: true
  validates :project_id, uniqueness: { scope: [ :contract_project_datum_id ], message: "Can't add same contract multiple times in same program."  }

  has_many :tasks
  has_many :issues
  has_many :risks
  has_many :lessons
  has_many :notes, as: :noteable, dependent: :destroy

  before_create :assign_default_facility_group 
  before_update :assign_default_facility_group 
  after_destroy :remove_roles

  def remove_roles
    RoleUser.where(project_contract_id: self.id).destroy_all
  end

  def assign_default_facility_group
    if self.facility_group.nil?
      self.facility_group_id = project.default_facility_group.id
    end
  end
end
