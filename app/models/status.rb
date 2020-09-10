class Status < SortableRecord
  default_scope {order(Status.order_humanize)}
  validates :name, presence: true
  validates_uniqueness_of :name, case_sensitive: false
end
