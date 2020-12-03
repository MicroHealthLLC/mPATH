class TaskType < SortableRecord
  default_scope {order(TaskType.order_humanize)}
  has_many :tasks
  has_many :facility_projects, through: :tasks
  has_many :facilities, through: :facility_projects
  validates :name, presence: true
  validates_uniqueness_of :name, case_sensitive: false

  def progress
  	fp = self.facility_projects
    fp.map(&:progress).sum / fp.size rescue 0
  end

end
