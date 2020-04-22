class TaskType < ApplicationRecord
  has_many :tasks
  validates_uniqueness_of :name, case_sensitive: false
  validates :name, presence: true
end
