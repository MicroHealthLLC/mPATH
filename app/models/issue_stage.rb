class IssueStage < SortableRecord
  default_scope {order(IssueStage.order_humanize)}
  validates :name, presence: true
  validates_uniqueness_of :name, case_sensitive: false
end
