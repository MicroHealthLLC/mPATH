class RoleUser < ApplicationRecord
  belongs_to :user
  belongs_to :role
  # belongs_to :facility
  # belongs_to :contract
  # belongs_to :project


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
