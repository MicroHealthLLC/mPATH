class FacilityProject < ApplicationRecord
  belongs_to :facility
  belongs_to :project
  belongs_to :status, optional: true
  has_many :tasks, dependent: :destroy
  has_many :task_types, through: :tasks
  has_many :issues, dependent: :destroy
  has_many :notes, as: :noteable, dependent: :destroy

  scope :active, -> {joins(:facility).where("facilities.status = ?", 1).distinct}

  def as_json(options=nil)
    json = super(options)
    return json.merge(
      facility: self.facility.as_json,
      tasks: tasks.map(&:to_json),
      issues: issues.map(&:to_json),
      notes: notes.map(&:to_json),
      project_status: status_name,
      color: color,
      progress: progress
    ).as_json if options.nil?
    json
  end

  def status_name
    status.try(:name)
  end

  def color
    status.try(:color) || '#ff0000'
  end

  def progress
    t = tasks
    t.map(&:progress).sum / t.size rescue 0
  end
end
