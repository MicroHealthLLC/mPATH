class Task < ApplicationRecord
  default_scope {order(due_date: :asc)}

  belongs_to :facility_project
  belongs_to :task_type
  belongs_to :task_stage
  has_many :task_users, dependent: :destroy
  has_many :users, through: :task_users
  has_many :checklists, as: :listable, dependent: :destroy
  has_many_attached :task_files, dependent: :destroy

  has_many :related_tasks, as: :relatable, dependent: :destroy
  has_many :related_issues, as: :relatable, dependent: :destroy
  has_many :sub_tasks, through: :related_tasks
  has_many :sub_issues, through: :related_issues

  has_many :notes, as: :noteable, dependent: :destroy

  validates :text, presence: true
  validates_numericality_of :progress, greater_than_or_equal_to: 0, less_than_or_equal_to: 100
  accepts_nested_attributes_for :checklists, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :notes, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :facility_project, reject_if: :all_blank

  scope :complete, -> {where("progress = ?", 100)}
  scope :incomplete, -> {where("progress < ?", 100)}

  before_save :check_watched, if: :watched_changed?
  after_save :handle_related_tasks_issues

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
      task_stage: self.task_stage.try(:name),
      user_ids: self.users.pluck(:id),
      users: self.users.map(&:full_name),
      checklists: self.checklists.as_json(include: {user: {methods: :full_name}}),
      notes: self.notes.as_json(include: {user: {methods: :full_name}}),
      facility_id: self.facility_project.try(:facility_id),
      facility_name: self.facility_project.try(:facility).facility_name,
      project_id: self.facility_project.try(:project_id),
      sub_tasks: self.sub_tasks.as_json(only: [:text, :id]),
      sub_issues: self.sub_issues.as_json(only: [:title, :id]),
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
    return unless params[:task][:task_files].present?
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

  def nuke_it!
    RelatedTask.where(task_id: self.id).or(RelatedTask.where(relatable: self)).destroy_all
  end

  def destroy
    nuke_it!
    super
  end

  def handle_related_tasks_issues
    sub_tasks.each{|t| t.sub_tasks << self unless t.sub_tasks.include? self}
    sub_issues.each{|i| i.sub_tasks << self unless i.sub_tasks.include? self}
    RelatedTask.where(task_id: self.id, relatable_type: 'Task').where.not(relatable_id: sub_task_ids).destroy_all
    RelatedIssue.where(issue_id: self.id, relatable_type: 'Task').where.not(relatable_id: sub_issue_ids).destroy_all
  end
end
