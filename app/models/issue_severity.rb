class IssueSeverity < SortableRecord
  default_scope {order(IssueSeverity.order_humanize)}
  validates :name, presence: true
  validates_uniqueness_of :name, case_sensitive: false
end
