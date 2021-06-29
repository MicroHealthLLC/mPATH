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

  before_save :check_for_admin_privileges

  PRIVILEGE_MODULE = ["admin", "overview", "tasks", "issues", "risks", "notes", "lessons"]
  PRIVILEGE_PERMISSIONS = [['Read', 'R'], ['Write', 'W'], ['Delete', 'D'] ]

  validates :project_ids, presence: true
  validates :user_id, presence: true, on: :update

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

end
