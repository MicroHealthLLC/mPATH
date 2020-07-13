class TaskType < ApplicationRecord
  has_many :tasks
  has_many :facility_projects, through: :tasks
  has_many :facilities, through: :facility_projects
  validates :name, presence: true
  validates_uniqueness_of :name, case_sensitive: false

  def progress
    self.facility_projects.map(&:progress).sum / self.facility_projects.count rescue 0
  end

  def gantt_hash(hash, p_id)
    tt_id = "#{p_id}_tt_#{self.id}"
    tt_s_date = facilities.map(&:start_date).compact.min
    tt_e_date = facilities.map(&:end_date).compact.max
    tt_duration = ((tt_e_date.to_time - tt_s_date.to_time) / 1.days).to_i * 24 * 60 * 60 * 1000
    hash.push({id: tt_id, parent_id: p_id, name: self.try(:name), duration: tt_duration, percent: progress, start_date: tt_s_date, end_date: tt_e_date, type: 'task'})
    tt_id
  end
end
