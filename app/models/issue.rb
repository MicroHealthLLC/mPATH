class Issue < ApplicationRecord
  default_scope {order(due_date: :desc)}

  belongs_to :facility_project
  belongs_to :issue_type
  belongs_to :issue_severity
  belongs_to :issue_status

  def as_json(options=nil)
    json = super(options)
    json.merge(
      issue_type: self.issue_type.try(:name),
      issue_severity: self.issue_severity.try(:name),
      issue_status: self.issue_status.try(:name)
    ).as_json
  end
end
