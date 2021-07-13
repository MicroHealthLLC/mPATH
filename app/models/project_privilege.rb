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

  serialize :project_ids, Array

  before_save :add_read_privilege
  before_save :check_for_admin_privileges

  PRIVILEGE_MODULE = ["admin", "overview", "tasks", "issues", "risks", "notes", "lessons"]
  PRIVILEGE_PERMISSIONS = [['Read', 'R'], ['Write', 'W'], ['Delete', 'D'] ]

  validates :project_ids, presence: true
  validates :user_id, presence: true, on: :update
  validate :check_minimum_privilege

  def check_minimum_privilege
    fp = self
    if !fp.admin.join.present? && !fp.overview.join.present? && !fp.tasks.join.present? && !fp.issues.join.present? && !fp.risks.join.present? && !fp.notes.join.present? && !fp.lessons.join.present?
      fp.errors.add(:base, "Program privileges can not be blank")
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
    if fp.admin && !fp.admin.include?("R") && ( fp.admin & ["W", "D"]).any?
      fp.admin = (fp.admin + ["R"]).uniq
    end
    if fp.overview && !fp.overview.include?("R") && ( fp.overview & ["W", "D"]).any?
      fp.overview = (fp.overview + ["R"]).uniq
    end
    if fp.tasks && !fp.tasks.include?("R") && ( fp.tasks & ["W", "D"]).any?
      fp.tasks = (fp.tasks + ["R"]).uniq
    end
    if fp.issues && !fp.issues.include?("R") && ( fp.issues & ["W", "D"]).any?
      fp.issues = (fp.issues + ["R"]).uniq
    end
    if fp.risks && !fp.risks.include?("R") && ( fp.risks & ["W", "D"]).any?
      fp.risks = (fp.risks + ["R"]).uniq
    end
    if fp.notes && !fp.notes.include?("R") && ( fp.notes & ["W", "D"]).any?
      fp.notes = (fp.notes + ["R"]).uniq
    end
    if fp.lessons && !fp.lessons.include?("R") && ( fp.lessons & ["W", "D"]).any?
      fp.lessons = (fp.lessons + ["R"]).uniq
    end
  end

end
