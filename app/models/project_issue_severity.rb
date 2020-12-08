class ProjectIssueSeverity < ApplicationRecord
  belongs_to :project
  belongs_to :issue_severity
end
