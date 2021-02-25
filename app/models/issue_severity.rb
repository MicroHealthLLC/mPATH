class IssueSeverity < SortableRecord
  # default_scope {order(IssueSeverity.order_humanize)}
  validates :name, presence: true
  validates_uniqueness_of :name, case_sensitive: false

  has_many :project_issue_severities
  has_many :projects, through: :project_issue_severities
end
