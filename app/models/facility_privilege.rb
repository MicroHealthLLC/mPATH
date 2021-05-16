class FacilityPrivilege < ApplicationRecord
  belongs_to :user
  # belongs_to :facility_project
  # belongs_to :facility, optional: true
  belongs_to :project

  serialize :overview, Array
  serialize :admin, Array
  serialize :tasks, Array
  serialize :issues, Array
  serialize :risks, Array
  serialize :notes, Array
  serialize :facility_project_ids, Array

  validates_presence_of :project_id, :facility_project_ids

  PRIVILEGE_MODULE = ["overview", "admin", "tasks", "issues", "risks", "notes"]
  PRIVILEGE_PERMISSIONS = [['Read', 'R'], ['Write', 'W'], ['Delete', 'D'] ]

  def get_permission_hash(permission_str)
    h = {read: false, write: false, delete: false, hide: true}
    permission_str.chars.each do |r|
      h[:read] = true if r == "R"
      h[:write] = true if r == "W"
      h[:delete] = true if r == "D"
      h[:hide] = (!h[:read] && !h[:write] && !h[:delete])
    end
    h
  end

  def to_json
    {
      overview: get_permission_hash( self.overview.join("") ),
      admin: get_permission_hash(  self.admin.join("") ),
      tasks: get_permission_hash(  self.tasks.join("") ),
      issues: get_permission_hash( self.issues.join("") ),
      risks: get_permission_hash( self.risks.join("") ),
      notes: get_permission_hash( self.notes.join("")),
      facility_project_id: self.facility_project_id,
      project_id: self.facility_id,
      program_id: self.facility_project.project_id
    }
  end

end
