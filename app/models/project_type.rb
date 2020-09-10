class ProjectType < SortableRecord
  default_scope {order(ProjectType.order_humanize)}
  has_many :projects
  validates :name, presence: true
  validates_uniqueness_of :name, case_sensitive: false
end
