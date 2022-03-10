class Role < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :project, optional: true
  has_many :role_users
  has_many :users, through: :role_users
end