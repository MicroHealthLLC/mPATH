class Role < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :project, optional: true
  has_many :role_users, dependent: :destroy
  has_many :users, through: :role_users
  has_many :role_privileges, dependent: :destroy
  accepts_nested_attributes_for :role_privileges
  
  validate :prevent_default_role_update, on: [:update, :destroy]
  validates :name, presence: true #, acceptance: {message: "must be present in Role"}

  def prevent_default_role_update
    if is_default
      self.errors.add(:base, "Can not update default role.")
      return false
    end
    return true
  end

  # def destroy
  #   raise "Can not destroy default role." if !prevent_default_role_update
  #   super
  # end
  def self.preload_array
    [:role_privileges, {role_users: [:user, :role, {facility_project: :facility}, :project_contract] }]
  end

  def to_json(options = {})
    hash = self.attributes
    hash[:role_privileges] = []
    hash[:role_users] = []

    if options[:page] == "user_tab_role_assign"
      hash[:facility_projects] = self.role_users.map(&:facility_project).compact.uniq.map{|f| {id: f.id, name: f.facility.facility_name} }

      hash[:contracts] = self.role_users.map(&:project_contract).compact.uniq.map{|f| {project_contract_id: f.id, name: f.contract_project_datum&.name} }
    end

    if options[:include] && ( options[:include].include?(:role_privileges) || options[:include].include?(:all) )
      hash[:role_privileges] = self.role_privileges.as_json
    end

    if options[:include] && ( options[:include].include?(:role_users)|| options[:include].include?(:all) )
      hash[:role_users] = self.role_users.map(&:to_json)
    end
    
    hash
  end
  
  def is_admin_role?
    role_privileges.where(role_type: RolePrivilege::PROGRAM_SETTINGS_ROLE_TYPES).count > 0
  end

  def self.program_admin_user_role
    Role.where(name: "program-admin").first
  end

  def self.default_roles
    where(is_default: true).distinct
  end
  
  def self.not_default_roles
    where(is_default: false).distinct
  end

  def create_or_update_role(params, user)
    p_role = params
    if params[:id]
      role = Role.find(params[:id])
    else
      role = self
    end

    role.transaction do
      role.name = p_role[:name]
      role.is_portfolio = false
      role.project_id = p_role[:project_id]
      role.user_id = user.id
      role.is_default = false
      role.type_of = p_role[:type_of]
      p_role_privileges = p_role[:role_privileges] || []
      role.role_privileges_attributes = p_role_privileges if p_role_privileges.any?
      role.save
    end
    role
  end

end