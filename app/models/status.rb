class Status < SortableRecord
  # default_scope {order(Status.order_humanize)}
  has_many :project_statuses
  has_many :projects, through: :project_statuses

  validates :name, presence: true
  validates_uniqueness_of :name, case_sensitive: false

  def self.not_started
    Status.find_or_create_by(name: "Not Started" ) do |s|
      s.color = "#000000"
    end
  end

end
