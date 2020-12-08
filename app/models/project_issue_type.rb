class ProjectIssueType < ApplicationRecord
  belongs_to :project
  belongs_to :issue_type
end
