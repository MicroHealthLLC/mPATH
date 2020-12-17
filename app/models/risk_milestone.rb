class RiskMilestone < SortableRecord
  default_scope {order(RiskMilestone.order_humanize)}
  validates :name, presence: true
  validates_uniqueness_of :name, case_sensitive: false
end
