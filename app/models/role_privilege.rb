class RolePrivilege < ApplicationRecord

  # This roles are used to access project related data e.g. tasks issues risks
  PROJECT_ANALYTICS = 'project_analytics'
  PROJECT_TASKS = 'project_tasks'
  PROJECT_ISSUES = 'project_issues'
  PROJECT_RISKS = 'project_risks'
  PROJECT_LESSONS = 'project_lessons'
  PROJECT_NOTES = 'project_notes'

  PROJECT_PRIVILEGS_ROLE_TYPES = [PROJECT_ANALYTICS, PROJECT_TASKS, PROJECT_ISSUES, PROJECT_RISKS, PROJECT_LESSONS, PROJECT_NOTES]

  # This roles are used to access contract related data e.g. task, issues risks
  CONTRACT_ANALYTICS = 'contract_analytics'
  CONTRACT_TASKS = 'contract_tasks'
  CONTRACT_ISSUES = 'contract_issues'
  CONTRACT_RISKS = 'contract_risks'
  CONTRACT_LESSONS = 'contract_lessons'
  CONTRACT_NOTES = 'contract_notes'
  
  CONTRACT_PRIVILEGS_ROLE_TYPES = [CONTRACT_ANALYTICS, CONTRACT_TASKS, CONTRACT_ISSUES, CONTRACT_RISKS, CONTRACT_LESSONS, CONTRACT_NOTES]
  
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
