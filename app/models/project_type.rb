class ProjectType < ApplicationRecord
  has_many :projects
  validates_uniqueness_of :name, case_sensitive: false
end
