class Task < ApplicationRecord
  default_scope {order(due_date: :asc)}

  belongs_to :facility_project
  belongs_to :task_type
  has_many :task_users, dependent: :destroy
  has_many :users, through: :task_users
  has_many :checklists, as: :listable
  has_many_attached :task_files, dependent: :destroy

  has_many :related_tasks, as: :relatable
  has_many :related_issues, as: :relatable
  has_many :sub_tasks, through: :related_tasks
  has_many :sub_issues, through: :related_issues

  validates :text, presence: true
  validates_numericality_of :progress, greater_than_or_equal_to: 0, less_than_or_equal_to: 100
  accepts_nested_attributes_for :checklists, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :facility_project, reject_if: :all_blank

  scope :complete, -> {where("progress = ?", 100)}
  scope :incomplete, -> {where("progress < ?", 100)}

  before_save :check_watched, if: :watched_changed?

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
      task_type: self.task_type.try(:name),
      user_ids: self.users.pluck(:id),
      users: self.users.map(&:full_name),
      checklists: self.checklists.as_json(include: {user: {methods: :full_name}}),
      facility_id: self.facility_project.try(:facility_id),
      facility_name: self.facility_project.try(:facility).facility_name,
      project_id: self.facility_project.try(:project_id),
      sub_task_ids: self.sub_task_ids,
      sub_issue_ids: self.sub_issue_ids
    ).as_json
  end

  def files_as_json
    task_files.map do |file|
      {
        id: file.id,
        name: file.blob.filename,
        uri: Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true)
      }
    end.as_json
  end

  def manipulate_files(params)
    file_blobs = JSON.parse(params[:task][:task_files])
    file_blobs.each do |file|
      if file['_destroy']
        self&.task_files.find_by_id(file['id'])&.purge
      elsif file['_new']
        self&.task_files.create(blob_id: file['id'])
      end
    end
  end

  def project
    self.facility_project.try(:project)
  end

  def facility
    self.facility_project.try(:facility)
  end

  def check_watched
    self.watched_at = DateTime.now
  end
end
