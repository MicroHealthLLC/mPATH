
# NOTE: in facility_project_ids it is saving facility ids

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
  before_save :add_read_privilege
  before_save :check_for_admin_privileges

  validate :check_minimum_privilege

  PRIVILEGE_MODULE = ["admin", "overview", "tasks", "issues", "risks", "notes", "lessons"]
  PRIVILEGE_PERMISSIONS = [['Read', 'R'], ['Write', 'W'], ['Delete', 'D'] ]

  def check_minimum_privilege
    fp = self
    if !fp.admin.join.present? && !fp.overview.join.present? && !fp.tasks.join.present? && !fp.issues.join.present? && !fp.risks.join.present? && !fp.notes.join.present? && !fp.lessons.join.present?
      fp.errors.add(:base, "Project Privileges can not be blank")
    end
  end

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

  def add_read_privilege
    fp = self
    if fp.admin && fp.admin_was && fp.admin_was.include?("R") && !fp.admin.include?("R")
      fp.admin = []
    elsif fp.admin && !fp.admin.include?("R") && ( fp.admin & ["W", "D"]).any?
      fp.admin = (fp.admin + ["R"]).uniq
    end

    if fp.overview && fp.overview_was && fp.overview_was.include?("R") && !fp.overview.include?("R")
      fp.overview = []
    elsif fp.overview && !fp.overview.include?("R") && ( fp.overview & ["W", "D"]).any?
      fp.overview = (fp.overview + ["R"]).uniq
    end
    
    if fp.tasks && fp.tasks_was && fp.tasks_was.include?("R") && !fp.tasks.include?("R")
      fp.tasks = []
    elsif fp.tasks && !fp.tasks.include?("R") && ( fp.tasks & ["W", "D"]).any?
      fp.tasks = (fp.tasks + ["R"]).uniq
    end
    
    if fp.issues && fp.issues_was && fp.issues_was.include?("R") && !fp.issues.include?("R")
      fp.issues = []
    elsif fp.issues && !fp.issues.include?("R") && ( fp.issues & ["W", "D"]).any?
      fp.issues = (fp.issues + ["R"]).uniq
    end
    
    if fp.risks && fp.risks_was && fp.risks_was.include?("R") && !fp.risks.include?("R")
      fp.risks = []
    elsif fp.risks && !fp.risks.include?("R") && ( fp.risks & ["W", "D"]).any?
      fp.risks = (fp.risks + ["R"]).uniq
    end
    
    if fp.notes && fp.notes_was && fp.notes_was.include?("R") && !fp.notes.include?("R")
      fp.notes = []
    elsif fp.notes && !fp.notes.include?("R") && ( fp.notes & ["W", "D"]).any?
      fp.notes = (fp.notes + ["R"]).uniq
    end
    
    if fp.lessons && fp.lessons_was && fp.lessons_was.include?("R") && !fp.lessons.include?("R")
      fp.lessons = []
    elsif fp.lessons && !fp.lessons.include?("R") && ( fp.lessons & ["W", "D"]).any?
      fp.lessons = (fp.lessons + ["R"]).uniq
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
