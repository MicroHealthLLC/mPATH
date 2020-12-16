class Status < SortableRecord
  default_scope {order(Status.order_humanize)}
  has_many :project_statuses
  has_many :projects, through: :project_statuses

  validates :name, presence: true
  validates_uniqueness_of :name, case_sensitive: false
end
