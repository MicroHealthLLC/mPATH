class Issue < ApplicationRecord
  default_scope {order(due_date: :asc)}

  belongs_to :facility_project
  belongs_to :issue_type
  belongs_to :issue_severity

  validates_numericality_of :progress, greater_than_or_equal_to: 0, less_than_or_equal_to: 100

  scope :complete, -> { where("progress = ?", 100) }
  scope :incomplete, -> { where("progress < ?", 100) }

  def as_json(options=nil)
    json = super(options)
    json.merge(
      issue_type: self.issue_type.try(:name),
      issue_severity: self.issue_severity.try(:name)
    ).as_json
  end
end
