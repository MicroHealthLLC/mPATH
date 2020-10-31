class Issue < ApplicationRecord
  default_scope {order(due_date: :asc)}

  belongs_to :facility_project
  belongs_to :issue_type
  belongs_to :issue_severity
  has_many :issue_users, dependent: :destroy
  has_many :users, through: :issue_users
  has_many :checklists, as: :listable
  has_many_attached :issue_files, dependent: :destroy

  has_many :related_tasks, as: :relatable
  has_many :related_issues, as: :relatable
  has_many :sub_tasks, through: :related_tasks
  has_many :sub_issues, through: :related_issues

  validates :title, presence: true
  validates_numericality_of :progress, greater_than_or_equal_to: 0, less_than_or_equal_to: 100
  accepts_nested_attributes_for :checklists, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :facility_project, reject_if: :all_blank

  scope :complete, -> {where("progress = ?", 100)}
  scope :incomplete, -> {where("progress < ?", 100)}

  before_save :check_watched, if: :watched_changed?

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
      checklists: self.checklists.as_json(include: {user: {methods: :full_name}}),
      facility_id: self.facility_project.try(:facility_id),
      facility_name: self.facility_project.try(:facility).facility_name,
      project_id: self.facility_project.try(:project_id),
      sub_task_ids: self.sub_task_ids,
      sub_issue_ids: self.sub_issue_ids
    ).as_json
  end

  def files_as_json
    issue_files.map do |file|
      {
        id: file.id,
        name: file.blob.filename,
        uri: Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true)
      }
    end.as_json
  end

  def manipulate_files(params)
    return unless params[:issue][:issue_files].present?
    file_blobs = JSON.parse(params[:issue][:issue_files])
    file_blobs.each do |file|
      if file['_destroy']
        self&.issue_files.find_by_id(file['id'])&.purge
      elsif file['_new']
        self&.issue_files.create(blob_id: file['id'])
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

  def nuke_it!
    RelatedIssue.where(issue_id: self.id).destroy_all
  end

  def destroy
    nuke_it!
    super
  end

end
