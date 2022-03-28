class RoleUser < ApplicationRecord
  belongs_to :user
  belongs_to :role
  belongs_to :project, optional: true
  belongs_to :facility, optional: true
  belongs_to :contract, optional: true

  def to_json(options={})
    role_user = self
    role_user.attributes.merge({user_full_name: role_user.user.full_name, role_name: role_user.role.name})
  end
end
