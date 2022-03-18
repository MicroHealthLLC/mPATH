class RolePrivilege < ApplicationRecord
  ROLE_TYPES = [
    "program_admin", "program_setting_groups", "program_setting_users", "program_setting_projects", "program_setting_contracts", 
    "project_analytics", "project_tasks", "project_issues", "project_risks", "project_lessons", "project_notes",
    "contract_analytics", "contract_tasks", "contract_issues", "contract_risks", "contract_lessons", "contract_notes"
  ]
  belongs_to :role
  validate :check_privileges

  PROJECT_PRIVILEGS_ROLE_TYPES = ["project_analytics", "project_tasks", "project_issues", "project_risks", "project_lessons", "project_notes"]
  CONTRACT_PRIVILEGS_ROLE_TYPES = ["contract_analytics", "contract_tasks", "contract_issues", "contract_risks", "contract_lessons", "contract_notes"]
  PROGRAM_ADMIN_PRIVILEGS_ROLE_TYPES = ["program_admin"]
  PROGRAM_SETTINGS_ROLE_TYPES = ["program_setting_groups", "program_setting_users", "program_setting_projects", "program_setting_contracts" ]

  def check_privileges
    role = self.role
    if role.role_privileges.exists?(role_type: self.role_type)
      self.errors.add(:base, "Role already exists")
      return false
    end
  end

end
