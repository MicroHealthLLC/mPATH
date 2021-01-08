class ProjectRole < ApplicationRecord
  belongs_to :project
  belongs_to :role
  has_many :project_users
end
