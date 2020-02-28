class Task < ApplicationRecord
  default_scope { order(due_date: :desc) }
  belongs_to :facility
  belongs_to :task_type
  has_many_attached :task_files
  validates_numericality_of :progress, in: 0..100

  def to_json
    attach_files = []
    if self.task_files.attached?
      attach_files = self.task_files.map do |file|
        {
          id: file.id,
          uri: Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true)
        }
      end
    end

    self.as_json.merge(
      attach_files: attach_files,
      task_type: self.task_type.try(:name)
    ).as_json
  end
end
