class IssueType < SortableRecord
  default_scope {order(IssueType.order_humanize)}
  validates :name, presence: true
  validates_uniqueness_of :name, case_sensitive: false
end
