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
  serialize :lessons, Array
  serialize :notes, Array
  serialize :facility_project_ids, Array

  validates_presence_of :project_id, :facility_project_ids
  before_save :remove_blank_string
  before_save :check_for_admin_privileges

  PRIVILEGE_MODULE = ["admin", "overview", "tasks", "issues", "risks", "notes", "lessons"]
  PRIVILEGE_PERMISSIONS = [['Read', 'R'], ['Write', 'W'], ['Delete', 'D'] ]

  def remove_blank_string
    overview.delete("")
    admin.delete("")
    tasks.delete("")
    issues.delete("")
    risks.delete("")
    notes.delete("")
    lessons.delete("")
  end

  def check_for_admin_privileges
    if admin && admin.any?
      # admin_changed? 
      # admin_was
      fp = self
      fp.overview = ( (fp.overview || []) + admin).compact.uniq
      fp.tasks = ( (fp.tasks || [])  + admin).compact.uniq
      fp.issues = ( (fp.issues || []) + admin).compact.uniq
      fp.risks = ( (fp.risks || []) + admin).compact.uniq
      fp.notes = ( (fp.notes || []) + admin).compact.uniq
      fp.lessons = ( (fp.lessons || []) + admin).compact.uniq
    end
  end

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
      lessons: get_permission_hash( self.lessons.join("")),
      facility_project_id: self.facility_project_id,
      project_id: self.facility_id,
      program_id: self.facility_project.project_id
    }
  end

end
