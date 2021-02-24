class TaskStage < SortableRecord
  # default_scope {order(TaskStage.order_humanize)}
  validates :name, presence: true
  validates_uniqueness_of :name, case_sensitive: false
  has_many :project_task_stages
  has_many :projects, through: :project_task_stages
end
