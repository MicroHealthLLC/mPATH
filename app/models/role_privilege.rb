class RolePrivilege < ApplicationRecord

  # This roles are used to access project related data e.g. tasks issues risks
  PROJECT_PRIVILEGS_ROLE_TYPES = ["project_analytics", "project_tasks", "project_issues", "project_risks", "project_lessons", "project_notes"]

  # This roles are used to access contract related data e.g. task, issues risks
  CONTRACT_PRIVILEGS_ROLE_TYPES = ["contract_analytics", "contract_tasks", "contract_issues", "contract_risks", "contract_lessons", "contract_notes"]
  
  PROGRAM_SETTING_GROUPS="program_setting_groups"
  PROGRAM_SETTING_USERS_ROLES="program_setting_users_roles"
  PROGRAM_SETTING_PROJECTS="program_setting_projects"
  PROGRAM_SETTING_CONTRACTS="program_setting_contracts"

  # This roles are used to access program_settings page in client side
  # if user user has any of this role privilege then they can access progra_settings page
  PROGRAM_SETTINGS_ROLE_TYPES = [PROGRAM_SETTING_GROUPS, PROGRAM_SETTING_USERS_ROLES, PROGRAM_SETTING_PROJECTS, PROGRAM_SETTING_CONTRACTS ]

  ALL_ROLE_TYPES = PROJECT_PRIVILEGS_ROLE_TYPES + CONTRACT_PRIVILEGS_ROLE_TYPES + PROGRAM_SETTINGS_ROLE_TYPES
  belongs_to :role
  validate :check_privileges, on: :create
  validates :role_type, inclusion: { in: ALL_ROLE_TYPES, message: "%{value} is not a valid role type" }
  validate :prevent_default_role_update, on: :update

  def prevent_default_role_update
    if self.role.is_default?
      self.errors.add(:base, "Can't modify default role privileges")
    end
  end
  def check_privileges
    role = self.role
    if role.role_privileges.exists?(role_type: self.role_type)
      self.errors.add(:base, "Role already exists")
      return false
    end
  end

end
