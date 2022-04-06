class Role < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :project, optional: true
  has_many :role_users, dependent: :destroy
  has_many :users, through: :role_users
  has_many :role_privileges, dependent: :destroy
  accepts_nested_attributes_for :role_privileges
  
  def to_json(options = {})
    hash = self.attributes
    hash[:role_privileges] = self.role_privileges.as_json
    hash[:role_users] = self.role_users.includes(:user).map(&:to_json)
    hash
  end
  
  def self.program_admin_role
    Role.where(name: "program-admin").first
  end

  def self.default_roles
    where(is_default: true)
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