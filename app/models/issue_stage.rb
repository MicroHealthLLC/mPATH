class IssueStage < SortableRecord
  # default_scope {order(IssueStage.order_humanize)}
  validates :name, presence: true
  validates_uniqueness_of :name, case_sensitive: false
  has_many :project_issue_stages
  has_many :projects, through: :project_issue_stages
end
