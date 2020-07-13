class Project < ApplicationRecord
  has_many :tasks, through: :facilities
  has_many :project_users, dependent: :destroy
  has_many :users, through: :project_users
  has_many :facility_projects, dependent: :destroy
  has_many :facilities, through: :facility_projects
  has_many :facility_groups, through: :facilities
  has_many :tasks, through: :facility_projects
  has_many :comments, as: :resource, dependent: :destroy, class_name: 'ActiveAdmin::Comment'
  accepts_nested_attributes_for :comments, reject_if: :reject_comment

  belongs_to :project_type

  enum status: [:inactive, :active].freeze

  validates_uniqueness_of :name, case_sensitive: false
  validates :name, presence: true

  before_create :set_uuid
  after_save :grant_access_to_admins

  def as_json(options=nil)
    json = super(options)
    json.merge(
      project_type: self.project_type.try(:name),
      tasks_count: self.tasks.count,
      tasks_complete: self.tasks.complete.count,
      tasks_incomplete: self.tasks.incomplete.count,
      facility_count: self.facilities.count
    ).as_json
  end

  def reject_comment(comment)
    comment['body'].blank?
  end

  def progress
    self.tasks.map(&:progress).sum / self.tasks.count rescue 0
  end

  def gantt_data
    hash = Array.new
    gantt_hash(hash)
    hash.uniq
  end

  def gantt_hash(hash)
    p_id = "p_#{self.id}"
    p_s_date = facilities.map(&:start_date).compact.min
    p_e_date = facilities.map(&:end_date).compact.max
    p_duration = ((p_e_date.to_time - p_s_date.to_time) / 1.days).to_i * 24 * 60 * 60 * 1000
    hash.push({id: p_id, name: self.try(:name), duration: p_duration, percent: progress, start_date: p_s_date, end_date: p_e_date, type: 'project'})
    facility_groups.each do |facility_group|
      facility_group.gantt_hash(hash, p_id, id)
    end
  end

  private
    def set_uuid
      self.uuid = SecureRandom.uuid
    end

    def grant_access_to_admins
      self.users << User.admin.where.not(id: self.users.ids)
    end
end
