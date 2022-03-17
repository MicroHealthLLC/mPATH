class Role < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :project, optional: true
  has_many :role_users, dependent: :destroy
  has_many :users, through: :role_users
  has_many :role_privileges, dependent: :destroy

  def to_json(options = {})
    hash = self.attributes
    hash[:role_privileges] = self.role_privileges.as_json
    hash[:role_users] = self.role_users.as_json
    hash
  end

  def create_or_update_role(params, user)
    p_role = params
    if params[:id]
      role = Role.find(params[:id])
    else
      role = self
    end
  
    role.name = p_role[:name]
    role.is_portfolio = false
    role.project_id = p_role[:project_id]
    role.user_id = user.id
    role.is_default = false
    role.type_of = ""
    return role if !role.save
    role_privileges = role.role_privileges
    ( p_role[:role_privileges] || []).each do |p_role_privilege|
      p_role_privilege.merge!({role_id: role.id})
      if p_role_privilege[:id]
        rp = role_privileges.detect{|rp| rp.id == p_role_privilege[:id]}
        rp.update(p_role_privilege)
      else
        RolePrivilege.create(p_role_privilege)
      end
    end
    role
  end

end