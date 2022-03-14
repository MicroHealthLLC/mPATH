class RolePrivilege < ApplicationRecord
  ROLE_TYPES = [
    "program_admin", "groups", "users", "projects", "contracts", 
    "project_analytics", "project_tasks", "project_issues", "project_risks", "project_lessons", "project_notes",
    "contract_analytics", "contract_tasks", "contract_issues", "contract_risks", "contract_lessons", "contract_notes"
  ]
  belongs_to :role
  validate :check_privileges

  def check_privileges
    role = self.role
    if role.role_privileges.exists?(role_type: self.role_type)
      self.errors.add(:base, "Role already exists")
      return false
    end
  end

end
