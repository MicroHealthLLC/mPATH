class Task < ApplicationRecord
  default_scope {order(due_date: :desc)}

  delegate :project, to: :facility_project, allow_nil: true
  delegate :facility, to: :facility_project, allow_nil: true

  belongs_to :facility_project
  belongs_to :task_type
  has_many_attached :task_files, dependent: :destroy

  validates_numericality_of :progress, greater_than_or_equal_to: 0, less_than_or_equal_to: 100

  scope :complete, -> { where("progress = ?", 100) }
  scope :incomplete, -> { where("progress < ?", 100) }

  def to_json
    attach_files = []
    if self.task_files.attached?
      attach_files = self.task_files.map do |file|
        {
          id: file.id,
          name: file.blob.filename,
          uri: Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true)
        }
      end
    end

    self.as_json.merge(
      attach_files: attach_files,
      task_type: self.task_type.try(:name)
    ).as_json
  end

  def project_id
    self.facility_project.try(:project_id)
  end

  def facility_id
    self.facility_project.try(:facility_id)
  end

end
