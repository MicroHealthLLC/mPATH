class RoleUser < ApplicationRecord
  belongs_to :user
  belongs_to :role
  belongs_to :facility_project, optional: true
  belongs_to :contract, optional: true
  belongs_to :project, optional: true

  validate :check_valid_data
  validates_uniqueness_of :user_id, scope: %i[role_id facility_project_id], message: "Role is already assigned"
  validates_uniqueness_of :user_id, scope: %i[role_id contract_id], message: "Role is already assigned"
  validates_uniqueness_of :user_id, scope: %i[role_id project_id], message: "Role is already assigned"

  def check_valid_data
    if !facility_project_id && !contract_id && !project_id
      self.errors.add(:base, "One of the facility project, contract or project must be assigned!")
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
