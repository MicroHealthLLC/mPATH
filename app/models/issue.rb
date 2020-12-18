class Issue < ApplicationRecord
  include Normalizer
  default_scope {order(due_date: :asc)}

  belongs_to :facility_project
  belongs_to :issue_type
  belongs_to :issue_stage, optional: true
  belongs_to :task_type, optional: true
  belongs_to :issue_severity
  has_many :issue_users, dependent: :destroy
  has_many :users, through: :issue_users
  has_many :checklists, as: :listable, dependent: :destroy
  has_many_attached :issue_files, dependent: :destroy

  has_many :related_tasks, as: :relatable, dependent: :destroy
  has_many :related_issues, as: :relatable, dependent: :destroy
  has_many :sub_tasks, through: :related_tasks
  has_many :sub_issues, through: :related_issues

  has_many :notes, as: :noteable, dependent: :destroy

  validates :title, :start_date, :due_date, presence: true
  validates_numericality_of :progress, greater_than_or_equal_to: 0, less_than_or_equal_to: 100
  accepts_nested_attributes_for :checklists, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :notes, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :facility_project, reject_if: :all_blank

  scope :complete, -> {where("progress = ?", 100)}
  scope :incomplete, -> {where("progress < ?", 100)}

  before_save :check_watched, if: :watched_changed?
  before_update :update_progress_on_stage_change, if: :issue_stage_id_changed?
  after_save :handle_related_tasks_issues
  before_save :init_kanban_order, if: Proc.new {|issue| issue.issue_stage_id_was.nil?}

  after_save :remove_on_watch


  def remove_on_watch
    if self.progress == 100 && self.watched == true
      self.update(watched: false)
    end
  end

  def to_json
    attach_files = []
    i_files = self.issue_files
    if i_files.attached?
      attach_files = i_files.map do |file|
        {
          id: file.id,
          name: file.blob.filename,
          uri: Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true)
        }
      end
    end

    fp = self.facility_project
    users = self.users
    sub_tasks = self.sub_tasks
    sub_issues = self.sub_issues

    self.as_json.merge(
      class_name: self.class.name,
      attach_files: attach_files,
      is_overdue: progress < 100 && (due_date < Date.today),
      issue_type: issue_type.try(:name),
      issue_stage: issue_stage.try(:name),
      issue_severity: issue_severity.try(:name),
      responsible_user_names: users.map(&:full_name).compact.join(", "),
      user_ids: users.map(&:id).compact.uniq,
      users: users.as_json(only: [:id, :full_name, :title, :phone_number, :first_name, :last_name, :email]),
      checklists: checklists.as_json,
      notes: notes.as_json,
      facility_id: fp.try(:facility_id),
      facility_name: fp.try(:facility).facility_name,
      project_id: fp.try(:project_id),
      sub_tasks: sub_tasks.as_json(only: [:text, :id]),
      sub_issues: sub_issues.as_json(only: [:title, :id]),
      sub_task_ids: sub_tasks.map(&:id),
      sub_issue_ids: sub_issues.map(&:id)
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

  # This method is currently just creating Issue and not updating it
  # In future we will use this method in background process
  def create_or_update_issue(params, user)

    issue_params = params.require(:issue).permit(
      :title,
      :description,
      :issue_type_id,
      :issue_stage_id,
      :issue_severity_id,
      :task_type_id,
      :progress,
      :start_date,
      :due_date,
      :auto_calculate,
      :watched,
      :kanban_order,
      issue_files: [],
      user_ids: [],
      sub_task_ids: [],
      sub_issue_ids: [],
      checklists_attributes: [
        :id,
        :_destroy,
        :text,
        :user_id,
        :checked,
        :due_date
      ],
      notes_attributes: [
        :id,
        :_destroy,
        :user_id,
        :body
       ]
    )

    project = user.projects.active.find_by(id: params[:project_id])
    facility_project = project.facility_projects.find_by(facility_id: params[:facility_id])

    issue = self
    i_params = issue_params.dup
    user_ids = i_params.delete(:user_ids)
    sub_task_ids = i_params.delete(:sub_task_ids)
    sub_issue_ids = i_params.delete(:sub_issue_ids)
    checklists_attributes = i_params.delete(:checklists_attributes)
    notes_attributes = i_params.delete(:notes_attributes)

    issue.attributes = i_params
    issue.facility_project_id = facility_project.id

    issue.transaction do

      issue.save

      if user_ids && user_ids.present?
        issue_users_obj = []
        user_ids.each do |uid|
          next if !uid.present?
          issue_users_obj << IssueUser.new(issue_id: issue.id, user_id: uid)
        end
        IssueUser.import(issue_users_obj) if issue_users_obj.any?
      end

      if sub_task_ids && sub_task_ids.any?
        related_task_objs = []
        sub_task_ids.each do |sid|
          related_task_objs << RelatedTask.new(relatable_id: issue.id, relatable_type: issue.class.name, task_id: sid)
        end
        RelatedTask.import(related_task_objs) if related_task_objs.any?
      end

      if sub_issue_ids && sub_issue_ids.any?
        related_issue_objs = []
        sub_issue_ids.each do |sid|
          related_issue_objs << RelatedIssue.new(relatable_id: issue.id, relatable_type: issue.class.name, issue_id: sid)
        end
        RelatedIssue.import(related_issue_objs) if related_issue_objs.any?
      end

      if checklists_attributes.present?
        checklist_objs = []
        checklists_attributes.each do |key, value|
          value.delete("_destroy")
          checklist_objs << Checklist.new(value.merge({listable_id: issue.id, listable_type: issue.class.name}) )
        end
        Checklist.import(checklist_objs) if checklist_objs.any?
      end

      if notes_attributes.present?
        notes_objs = []
        notes_attributes.each do |key, value|
          value.delete("_destroy")
          notes_objs << Note.new(value.merge({noteable_id: issue.id, noteable_type: issue.class.name}) )
        end
        Note.import(notes_objs) if notes_objs.any?
      end

    end

    issue
  end


  def manipulate_files(params)
    return unless params[:issue][:issue_files].present?
    file_blobs = JSON.parse(params[:issue][:issue_files])
    file_blobs.each do |file|
      if file['_destroy']
        issue_files.find_by_id(file['id'])&.purge
      elsif file['_new']
        issue_files.new(blob_id: file['id'])
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
    RelatedIssue.where(issue_id: self.id).or(RelatedIssue.where(relatable: self)).destroy_all
  end

  def destroy
    nuke_it!
    super
  end

  def handle_related_tasks_issues
    sub_tasks.each{|t| t.sub_issues << self unless t.sub_issues.include? self}
    sub_issues.each{|i| i.sub_issues << self unless i.sub_issues.include? self}
    RelatedTask.where(task_id: self.id, relatable_type: 'Issue').where.not(relatable_id: sub_task_ids).destroy_all
    RelatedIssue.where(issue_id: self.id, relatable_type: 'Issue').where.not(relatable_id: sub_issue_ids).destroy_all
  end

  def update_progress_on_stage_change
    if issue_stage.present?
      self.progress = issue_stage.percentage
      self.auto_calculate = false
    end
  end

  def init_kanban_order
    self.kanban_order = facility_project.issues.where(issue_stage_id: issue_stage_id).maximum(:kanban_order) + 1 rescue 0 if self.issue_stage_id.present?
  end
end
