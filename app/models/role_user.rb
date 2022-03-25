class RoleUser < ApplicationRecord
  belongs_to :user
  belongs_to :role

  def to_json(options={})
    role_user = self
    role_user.attributes.merge({user_full_name: role_user.user.full_name, role_name: role_user.role.name})
  end
end
