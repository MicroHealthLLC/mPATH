class Issue < ApplicationRecord
  default_scope {order(due_date: :asc)}

  belongs_to :facility_project
  belongs_to :issue_type
  belongs_to :issue_severity
  has_many :issue_users, dependent: :destroy
  has_many :users, through: :issue_users
  has_many :checklists, as: :listable
  has_many_attached :issue_files, dependent: :destroy

  validates :title, presence: true
  validates_numericality_of :progress, greater_than_or_equal_to: 0, less_than_or_equal_to: 100
  accepts_nested_attributes_for :checklists, reject_if: :all_blank, allow_destroy: true

  scope :complete, -> {where("progress = ?", 100)}
  scope :incomplete, -> {where("progress < ?", 100)}

  def to_json
    attach_files = []
    if self.issue_files.attached?
      attach_files = self.issue_files.map do |file|
        {
          id: file.id,
          name: file.blob.filename,
          uri: Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true)
        }
      end
    end

    self.as_json.merge(
      attach_files: attach_files,
      issue_type: self.issue_type.try(:name),
      issue_severity: self.issue_severity.try(:name),
      user_ids: self.users.pluck(:id),
      checklists: self.checklists.as_json(include: {user: {methods: :full_name}})
    ).as_json
  end
end
