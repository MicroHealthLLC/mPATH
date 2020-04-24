class TaskType < ApplicationRecord
  has_many :tasks
  validates :name, presence: true
  validates_uniqueness_of :name, case_sensitive: false
  validates :name, presence: true
end
