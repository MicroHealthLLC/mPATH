class RoleUser < ApplicationRecord
  belongs_to :user
  belongs_to :role
  has_many :role_privileges, through: :role
  belongs_to :facility_project, optional: true
  belongs_to :project_contract, optional: true
  belongs_to :project_contract_vehicle, optional: true
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
    
    RoleUser.remove_bad_records

    if facility_project_id
      if RoleUser.where(user_id: user_id, role_id: role_id, facility_project_id: facility_project_id, project_id: project_id).exists?
        facility = self.facility_project.facility
        self.errors.add(:base, "#{role.name} is already assigned to #{facility.facility_name} to user #{user.full_name}")
        return false
      end
    elsif project_contract_id
      if RoleUser.where(user_id: user_id, role_id: role_id, project_contract_id: project_contract_id, project_id: project_id).exists?
        contract = self.project_contract
        self.errors.add(:base, "#{role.name} is already assigned to contract to user #{user.full_name}")
        return false
      end
    elsif project_contract_vehicle_id
      if RoleUser.where(user_id: user_id, role_id: role_id, project_contract_vehicle_id: project_contract_vehicle_id, project_id: project_id).exists?
        project_contract_vehicle = self.project_contract_vehicle
        self.errors.add(:base, "#{role.name} is already assigned to contract vehicle to user #{user.full_name}")
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
    if !facility_project_id && !project_contract_id && !project_contract_vehicle_id && !project_id
      self.errors.add(:base, "One of the facility project, contract, contract vehicle or project must be assigned!")
    end
    if RoleUser.where(user_id: self.user_id, project_id: self.project_id, facility_project_id: self.facility_project_id, project_contract_id: self.project_contract_id, project_contract_vehicle_id: self.project_contract_vehicle_id ).count > 0
      self.errors.add(:base, "Can't assign multiple roles on same project or contract or contract vehicle!")
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

  def self.remove_duplicate_records
    update_project_role = Role.find_by_name("update-project")
    read_project_role = Role.find_by_name("read-project")
    contribute_project_role = Role.find_by_name("contribute-project")
    
    # find duplicate record with facility_project
    _update_project_role = RoleUser.select(:role_id,:project_id, :facility_project_id, :user_id).where(role_id: update_project_role.id).group(:role_id,:project_id, :facility_project_id, :user_id).having("count(*) > 1")
    
    _read_project_role = RoleUser.select(:role_id,:project_id, :facility_project_id, :user_id).where(role_id: read_project_role.id).group(:role_id,:project_id, :facility_project_id, :user_id).having("count(*) > 1")
    
    _contribute_project_role = RoleUser.select(:role_id,:project_id, :facility_project_id, :user_id).where(role_id: contribute_project_role.id).group(:role_id,:project_id, :facility_project_id, :user_id).having("count(*) > 1")
    
    update_contract_role = Role.find_by_name("update-contract")
    read_contract_role = Role.find_by_name("read-contract")
    contribute_contract_role = Role.find_by_name("contribute-contract")
    
    # find duplicate record with contract
    _update_contract_role = RoleUser.select(:role_id,:project_id, :project_contract_id, :user_id).where(role_id: update_contract_role.id).group(:role_id,:project_id, :project_contract_id, :user_id).having("count(*) > 1")
    
    _read_contract_role = RoleUser.select(:role_id,:project_id, :project_contract_id, :user_id).where(role_id: read_contract_role.id).group(:role_id,:project_id, :project_contract_id, :user_id).having("count(*) > 1")
    
    _contribute_contract_role = RoleUser.select(:role_id,:project_id, :project_contract_id, :user_id).where(role_id: contribute_contract_role.id).group(:role_id,:project_id, :project_contract_id, :user_id).having("count(*) > 1")
    
    program_admin_role = Role.find_by_name("program-admin")
    # find duplicate record with project
    _program_admin_role = RoleUser.select(:role_id,:project_id,:user_id).where(role_id: program_admin_role.id).group(:role_id,:project_id, :user_id).having("count(*) > 1")

    RoleUser.remove_bad_records

    puts "Duplicate #{update_project_role.name} roles: #{_update_project_role.size}"
    puts "Duplicate #{read_project_role.name} roles: #{_read_project_role.size}"
    puts "Duplicate #{contribute_project_role.name} roles: #{_contribute_project_role.size}"
    puts "Duplicate #{update_contract_role.name} roles: #{_update_contract_role.size}"
    puts "Duplicate #{read_contract_role.name} roles: #{_read_contract_role.size}"
    puts "Duplicate #{contribute_contract_role.name} roles: #{_contribute_contract_role.size}"
    puts "Duplicate #{program_admin_role.name} roles: #{_program_admin_role.size}"

  end

  # Due to move and duplicate project and group to different program, 
  # there are several records which are not moved as expected.
  # this method will check if project is not part of program and still has role for user then 
  # it is an invalid record, hence remove it.
  def self.remove_bad_records
    bad_role_user_ids = []

    RoleUser.includes({facility_project: [:project]}).in_batches.each do |role_users|
      role_users.each do |role_user|
        if role_user.facility_project_id && role_user.project_id != role_user.facility_project.try(:project_id)
          bad_role_user_ids << role_user.id          
        end
      end
    end
    RoleUser.where(id: bad_role_user_ids).destroy_all
  end

end
