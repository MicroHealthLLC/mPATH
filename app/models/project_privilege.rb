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

  serialize :cn_overview, Array
  serialize :cn_tasks, Array
  serialize :cn_issues, Array
  serialize :cn_risks, Array
  serialize :cn_notes, Array
  serialize :cn_lessons, Array

  serialize :admin_groups, Array
  serialize :admin_contracts, Array
  serialize :admin_facilities, Array

  before_save :add_read_privilege
  before_save :check_for_admin_privileges
  before_save :remove_facility_privileges_on_save
  after_destroy :remove_facility_privileges

  # PRIVILEGE_MODULE = ["admin", "overview", "tasks", "issues", "risks", "notes", "lessons", "contracts"]
  # PRIVILEGE_MODULE = {admin: "admin", overview: "Project analytics", tasks: "Project tasks", issues: "Project issues", risks: "Project risks", notes: "Project notes", lessons: "Project lessons", cn_overview: "Contract analytics", cn_tasks: "Contract tasks", cn_issues: "Contract issues", cn_risks: "Contract risks", cn_notes: "Contract notes", cn_lessons: "Contract lessons", admin_groups: "Program setting groups", admin_facilities: "Program Setting Projects", admin_contracts: "Program Setting Contracts" }
  PRIVILEGE_MODULE = {admin: "admin", overview: "Project analytics", tasks: "Project tasks", issues: "Project issues", risks: "Project risks", notes: "Project notes", lessons: "Project lessons", contracts: "contracts", cn_overview: "Contract analytics", cn_tasks: "Contract tasks", cn_issues: "Contract issues", cn_risks: "Contract risks", cn_notes: "Contract notes", cn_lessons: "Contract lessons", admin_groups: "Program setting groups", admin_facilities: "Program Setting Projects", admin_contracts: "Program Setting Contracts" }
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
      fp.contracts = ( (fp.contracts || []) + admin).compact.uniq
  
      fp.cn_overview = ( (fp.cn_overview || []) + admin).compact.uniq
      fp.cn_tasks = ( (fp.cn_tasks || [])  + admin).compact.uniq
      fp.cn_issues = ( (fp.cn_issues || []) + admin).compact.uniq
      fp.cn_risks = ( (fp.cn_risks || []) + admin).compact.uniq
      fp.cn_notes = ( (fp.cn_notes || []) + admin).compact.uniq
      fp.cn_lessons = ( (fp.cn_lessons || []) + admin).compact.uniq

      fp.admin_groups = ( (fp.admin_groups || []) + admin).compact.uniq
      fp.admin_contracts = ( (fp.admin_contracts || []) + admin).compact.uniq
      fp.admin_facilities = ( (fp.admin_facilities || []) + admin).compact.uniq
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



    if fp.cn_overview && fp.cn_overview_was && fp.cn_overview_was.include?("R") && !fp.cn_overview.include?("R")
      fp.cn_overview = []
    elsif fp.cn_overview && !fp.cn_overview.include?("R") && ( fp.cn_overview & ["W", "D"]).any?
      fp.cn_overview = (fp.cn_overview + ["R"]).uniq
    end
    
    if fp.cn_tasks && fp.cn_tasks_was && fp.cn_tasks_was.include?("R") && !fp.cn_tasks.include?("R")
      fp.cn_tasks = []
    elsif fp.cn_tasks && !fp.cn_tasks.include?("R") && ( fp.cn_tasks & ["W", "D"]).any?
      fp.cn_tasks = (fp.cn_tasks + ["R"]).uniq
    end
    
    if fp.cn_issues && fp.cn_issues_was && fp.cn_issues_was.include?("R") && !fp.cn_issues.include?("R")
      fp.cn_issues = []
    elsif fp.cn_issues && !fp.cn_issues.include?("R") && ( fp.cn_issues & ["W", "D"]).any?
      fp.cn_issues = (fp.cn_issues + ["R"]).uniq
    end
    
    if fp.cn_risks && fp.cn_risks_was && fp.cn_risks_was.include?("R") && !fp.cn_risks.include?("R")
      fp.cn_risks = []
    elsif fp.cn_risks && !fp.cn_risks.include?("R") && ( fp.cn_risks & ["W", "D"]).any?
      fp.cn_risks = (fp.cn_risks + ["R"]).uniq
    end
    
    if fp.cn_notes && fp.cn_notes_was && fp.cn_notes_was.include?("R") && !fp.cn_notes.include?("R")
      fp.cn_notes = []
    elsif fp.cn_notes && !fp.cn_notes.include?("R") && ( fp.cn_notes & ["W", "D"]).any?
      fp.cn_notes = (fp.cn_notes + ["R"]).uniq
    end
    
    if fp.cn_lessons && fp.cn_lessons_was && fp.cn_lessons_was.include?("R") && !fp.cn_lessons.include?("R")
      fp.cn_lessons = []
    elsif fp.cn_lessons && !fp.cn_lessons.include?("R") && ( fp.cn_lessons & ["W", "D"]).any?
      fp.cn_lessons = (fp.cn_lessons + ["R"]).uniq
    end

  end

end
