class ProjectPrivilege < ApplicationRecord
  belongs_to :user
  # belongs_to :project

  serialize :overview, Array
  serialize :admin, Array
  serialize :tasks, Array
  serialize :issues, Array
  serialize :risks, Array
  serialize :notes, Array
  serialize :lessons, Array
  serialize :contracts, Array
  serialize :project_ids, Array

  before_save :add_read_privilege
  before_save :check_for_admin_privileges
  before_save :remove_facility_privileges_on_save
  after_destroy :remove_facility_privileges

  PRIVILEGE_MODULE = ["admin", "overview", "tasks", "issues", "risks", "notes", "lessons", "contracts"]
  PRIVILEGE_PERMISSIONS = [['Read', 'R'], ['Write', 'W'], ['Delete', 'D'] ]

  validate :validate_project_ids
  # validates :project_ids, presence: true
  validates :user_id, presence: true, on: :update
  validate :check_minimum_privilege
  
  def validate_project_ids
    if !project_ids.any?
      self.errors.add(" ", "Please select atleast one program in privilege")
    end
  end
  
  def remove_facility_privileges(pids = [])
    if !pids.any?
      pids = self.project_ids
    end
    facility_privileges = FacilityPrivilege.where(user_id: self.user_id, project_id: pids)
    facility_privileges.destroy_all
  end

  def remove_facility_privileges_on_save
    removed_project_ids = self.project_ids_was - self.project_ids
    if removed_project_ids.any?
      remove_facility_privileges(removed_project_ids)
    end
  end

  def check_minimum_privilege
    fp = self
    if !fp.admin.join.present? && !fp.overview.join.present? && !fp.tasks.join.present? && !fp.issues.join.present? && !fp.risks.join.present? && !fp.notes.join.present? && !fp.lessons.join.present?
      fp.errors.add(" ", "Program privileges can not be blank")
    end
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

end
