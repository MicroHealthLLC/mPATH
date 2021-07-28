class Note < ApplicationRecord
  # default_scope {order(updated_at: :desc)}

  belongs_to :noteable, polymorphic: true
  belongs_to :user
  has_many_attached :note_files, dependent: :destroy

  def json_for_lasson
    {
      id: id,
      user: user.full_name,
      body: body,
      created_at: created_at
    }
  end

  def portfolio_json
    {
      id: id,
      body: body,
      created_at: created_at,
      updated_at: updated_at
    }
  end

  def to_json
    attach_files = []
    n_files = self.note_files

    if n_files.attached?
      attach_files = n_files.map do |file|
        {
          id: file.id,
          name: file.blob.filename,
          uri: Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true)
        }
      end
    end
    self.as_json.merge(
      user: self.user.as_json(only: [:id, :full_name]),
      attach_files: attach_files
    ).as_json
  end

  def as_json(options=nil)
    json = super(options)
    json.merge(
      user: self.user.as_json(only: [:id, :full_name]),
    ).as_json
  end
end
