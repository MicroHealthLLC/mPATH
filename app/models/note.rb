class Note < ApplicationRecord
  default_scope {order(created_at: :desc)}

  belongs_to :noteable, polymorphic: true
  belongs_to :user
  has_many_attached :note_files

  def to_json
    attach_files = []
    if self.note_files.attached?
      attach_files = self.note_files.map do |file|
        {
          id: file.id,
          uri: Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true)
        }
      end
    end
    self.as_json.merge(
      user: self.user.as_json,
      attach_files: attach_files
    ).as_json
  end
end
