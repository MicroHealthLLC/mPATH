class RoleUser < ApplicationRecord
  belongs_to :user
  belongs_to :role
  has_many :role_privileges, through: :role
  belongs_to :facility_project, optional: true
  belongs_to :contract, optional: true
  belongs_to :project, optional: true

  validate :check_valid_data
  validate :check_duplication, on: :create
  validates :project_id, presence: true
  
  after_create :create_program_admin_record

  def create_program_admin_record
    admin_role = Role.program_admin_user_role
    if self.project_id && admin_role && (self.role_id == admin_role.id)
      if !self.project.user_ids.include?(self.user_id)
        ProjectUser.create(user_id: self.user_id, project_id: self.project_id) rescue nil
      end
    end
  end

  def check_only_single_admin_role
    user = self.user
    role = self.role
    if project_id && role.is_admin_role?
      role_users = RoleUser.includes(:role_privileges).where(user_id: user_id, project_id: project_id, "role_privileges.role_type" => RolePrivilege::PROGRAM_SETTINGS_ROLE_TYPES )
      if role_users.size > 0
        role_users.first.update(role_id: self.role_id)
        return true
      end
    end
  end

  def check_duplication
    user = self.user
    role = self.role
    if facility_project_id
      if RoleUser.where(user_id: user_id, role_id: role_id, facility_project_id: facility_project_id).exists?
        facility = self.facility_project.facility
        self.errors.add(:base, "#{role.name} is already assigned to #{facility.facility_name} to user #{user.full_name}")
        return false
      end
    elsif contract_id
      if RoleUser.where(user_id: user_id, role_id: role_id, contract_id: contract_id).exists?
        contract = self.contract
        self.errors.add(:base, "#{role.name} is already assigned to #{contract.name} to user #{user.full_name}")
        return false
      end
    elsif project_id
      if RoleUser.where(user_id: user_id, role_id: role_id, project_id: project_id).exists?
        project = self.project
        self.errors.add(:base, "#{role.name} is already assigned to #{project.name} to user #{user.full_name}")
        return false
      end
    end
  end

  def check_valid_data
    if !facility_project_id && !contract_id && !project_id
      self.errors.add(:base, "One of the facility project, contract or project must be assigned!")
    end
  end

  def check_authorized_data
    if project_id
      user = self.user
      project = self.project
      if !self.user.project_ids.include?(self.project_id)
        self.errors.add(:base, "Can't add role because #{user.name} is not part of #{project.name}")
      end
    end
  end

  def to_json(options={})
    role_user = self
    role_user.attributes.merge({user_full_name: role_user.user.full_name, role_name: role_user.role.name})
    # role_user.attributes.merge({
    #   user_full_name: role_user.user.full_name, 
    #   role_name: role_user.role.name,
    #   facility_name: role_user.facility&.facility_name || '',
    #   project_name: role_user.project&.name,
    #   contract_name: role_user.contract&.name || ''
    # })
  end
end
