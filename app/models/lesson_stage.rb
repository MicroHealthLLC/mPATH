class LessonStage < SortableRecord
  validates :name, presence: true
  validates_uniqueness_of :name, case_sensitive: false
  has_many :project_lesson_stages
  has_many :projects, through: :project_lesson_stages
end
