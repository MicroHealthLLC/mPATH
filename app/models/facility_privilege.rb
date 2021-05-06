class FacilityPrivilege < ApplicationRecord
  belongs_to :user
  belongs_to :facility_project
  belongs_to :facility, optional: true

  after_create :update_facility_id

  serialize :overview, Array
  serialize :admin, Array
  serialize :tasks, Array
  serialize :issues, Array
  serialize :risks, Array
  serialize :notes, Array

  def update_facility_id
    unless self.facility_id.present?
      f = self.facility_project
      self.update(facility_id: f.facility_id)
    end
  end 

  def to_json
    {
      overview: self.overview.join(""),
      admin: self.admin.join(""),
      tasks: self.tasks.join(""),
      issues: self.issues.join(""),
      risks: self.risks.join(""),
      notes: self.notes.join(""),
      facility_project_id: self.facility_project_id,
      project_id: self.facility_id 
    }
  end

end
