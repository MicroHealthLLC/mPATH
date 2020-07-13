class FacilityProject < ApplicationRecord
  belongs_to :facility
  belongs_to :project
  belongs_to :status, optional: true
  has_many :tasks, dependent: :destroy
  has_many :task_types, through: :tasks
  has_many :issues, dependent: :destroy
  has_many :notes, as: :noteable

  scope :active, -> {joins(:facility).where("facilities.status = ?", 1).distinct}

  def as_json(options=nil)
    json = super(options)
    return json.merge(
      facility: self.facility.as_json,
      tasks: self.tasks.map(&:to_json),
      issues: self.issues.map(&:to_json),
      notes: self.notes.map(&:to_json),
      project_status: status_name,
      color: color,
      progress: progress
    ).as_json if options.nil?
    json
  end

  def status_name
    self.status.try(:name)
  end

  def color
    self.status.try(:color) || '#ff0000'
  end

  def progress
    self.tasks.map(&:progress).sum / self.tasks.count rescue 0
  end

  def gantt_hash(hash, p_id)
    f_id = "#{p_id}_f_#{self.id}"
    f_s_date = facility.start_date
    f_e_date = facility.end_date
    f_duration = ((f_e_date.to_time - f_s_date.to_time) / 1.days).to_i * 24 * 60 * 60 * 1000 rescue 0

    hash.push({id: f_id, parent_id: p_id, name: facility.try(:facility_name), duration: f_duration, percent: progress, start_date: f_s_date, end_date: f_e_date, type: 'milestone'})

    task_types.each do |task_type|
      tt_id = task_type.gantt_hash(hash, f_id)
      tasks.where(task_type: task_type).each do |task|
        task.gantt_hash(hash, tt_id)
      end
    end
  end
end
