class IssueStatus < ApplicationRecord
  validates :name, presence: true
  validates_uniqueness_of :name, case_sensitive: false
end
