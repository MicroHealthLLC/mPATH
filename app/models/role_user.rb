class RoleUser < ApplicationRecord
  belongs_to :user
  belongs_to :role
  belongs_to :project, optional: true
  belongs_to :facility, optional: true
  belongs_to :contract, optional: true
end
