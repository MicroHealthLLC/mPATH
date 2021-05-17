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

  PRIVILEGE_MODULE = ["overview", "admin", "tasks", "issues", "risks", "notes", "lessons"]
  PRIVILEGE_PERMISSIONS = [['Read', 'R'], ['Write', 'W'], ['Delete', 'D'] ]

end
