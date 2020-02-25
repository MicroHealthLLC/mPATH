class Task < ApplicationRecord
  belongs_to :facility
  enum task_type: [:upgrade, :story]
  has_many_attached :task_files
  validates_numericality_of :progress, :in => 0..100

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
      attach_files: attach_files
    ).as_json
  end
end
