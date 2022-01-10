class ContractPrivilege < ApplicationRecord
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
  serialize :contract_ids, Array

  validates_presence_of :project_id, :contract_ids
  before_save :remove_blank_string
  before_save :add_read_privilege
  before_save :check_for_admin_privileges

  validate :check_minimum_privilege

  # PRIVILEGE_MODULE = ["admin", "overview", "tasks", "issues", "risks", "notes", "lessons"]
  PRIVILEGE_MODULE = {admin: "admin", overview: "analytics", tasks: "tasks", issues: "issues", risks: "risks", notes: "notes", lessons: "lessons" }
  PRIVILEGE_PERMISSIONS = [['Read', 'R'], ['Write', 'W'], ['Delete', 'D'] ]

  def check_minimum_privilege
    cp = self
    if !cp.admin.join.present? && !cp.overview.join.present? && !cp.tasks.join.present? && !cp.issues.join.present? && !cp.risks.join.present? && !cp.notes.join.present? && !cp.lessons.join.present?
      cp.errors.add(:base, "Project Privileges can not be blank")
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
      cp = self
      cp.overview = ( (cp.overview || []) + admin).compact.uniq
      cp.tasks = ( (cp.tasks || [])  + admin).compact.uniq
      cp.issues = ( (cp.issues || []) + admin).compact.uniq
      cp.risks = ( (cp.risks || []) + admin).compact.uniq
      cp.notes = ( (cp.notes || []) + admin).compact.uniq
      cp.lessons = ( (cp.lessons || []) + admin).compact.uniq
    end
  end

  def add_read_privilege
    cp = self
    if cp.admin && cp.admin_was && cp.admin_was.include?("R") && !cp.admin.include?("R")
      cp.admin = []
    elsif cp.admin && !cp.admin.include?("R") && ( cp.admin & ["W", "D"]).any?
      cp.admin = (cp.admin + ["R"]).uniq
    end

    if cp.overview && cp.overview_was && cp.overview_was.include?("R") && !cp.overview.include?("R")
      cp.overview = []
    elsif cp.overview && !cp.overview.include?("R") && ( cp.overview & ["W", "D"]).any?
      cp.overview = (cp.overview + ["R"]).uniq
    end
    
    if cp.tasks && cp.tasks_was && cp.tasks_was.include?("R") && !cp.tasks.include?("R")
      cp.tasks = []
    elsif cp.tasks && !cp.tasks.include?("R") && ( cp.tasks & ["W", "D"]).any?
      cp.tasks = (cp.tasks + ["R"]).uniq
    end
    
    if cp.issues && cp.issues_was && cp.issues_was.include?("R") && !cp.issues.include?("R")
      cp.issues = []
    elsif cp.issues && !cp.issues.include?("R") && ( cp.issues & ["W", "D"]).any?
      cp.issues = (cp.issues + ["R"]).uniq
    end
    
    if cp.risks && cp.risks_was && cp.risks_was.include?("R") && !cp.risks.include?("R")
      cp.risks = []
    elsif cp.risks && !cp.risks.include?("R") && ( cp.risks & ["W", "D"]).any?
      cp.risks = (cp.risks + ["R"]).uniq
    end
    
    if cp.notes && cp.notes_was && cp.notes_was.include?("R") && !cp.notes.include?("R")
      cp.notes = []
    elsif cp.notes && !cp.notes.include?("R") && ( cp.notes & ["W", "D"]).any?
      cp.notes = (cp.notes + ["R"]).uniq
    end
    
    if cp.lessons && cp.lessons_was && cp.lessons_was.include?("R") && !cp.lessons.include?("R")
      cp.lessons = []
    elsif cp.lessons && !cp.lessons.include?("R") && ( cp.lessons & ["W", "D"]).any?
      cp.lessons = (cp.lessons + ["R"]).uniq
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
      program_id: self.project_id,
      contract_ids: self.contract_ids
    }
  end

end
