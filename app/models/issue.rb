class Issue < ApplicationRecord
  default_scope {order(due_date: :desc)}

  belongs_to :facility_project
  belongs_to :issue_type
  belongs_to :issue_severity
  belongs_to :issue_status
end
