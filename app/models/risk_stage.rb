class RiskStage < SortableRecord
  default_scope {order(RiskStage.order_humanize)}
  validates :name, presence: true
  validates_uniqueness_of :name, case_sensitive: false
  has_many :project_risk_stages
  has_many :projects, through: :project_risk_stages
end
