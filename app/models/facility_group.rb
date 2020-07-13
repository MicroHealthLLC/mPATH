class FacilityGroup < ApplicationRecord
  has_many :facilities
  has_many :facility_projects, through: :facilities

  validates :name, presence: true, uniqueness: true

  enum status: [:inactive, :active].freeze

  def as_json(options=nil)
    json = super(options)
    json.merge(
      facilities: self.facility_projects.as_json,
      facility_count: self.facilities.count,
      project_ids: self.facility_projects.pluck(:project_id).uniq
    ).as_json
  end

  def progress
    self.facility_projects.map(&:progress).sum / self.facility_projects.count rescue 0
  end

  def gantt_hash(hash, p_id, project_id)
    fg_id = "#{p_id}_fg_#{self.id}"
    fg_s_date = facilities.map(&:start_date).compact.min
    fg_e_date = facilities.map(&:end_date).compact.max
    fg_duration = ((fg_e_date.to_time - fg_s_date.to_time) / 1.days).to_i * 24 * 60 * 60 * 1000 rescue 0

    hash.push({id: fg_id, parent_id: p_id, name: self.try(:name), duration: fg_duration, percent: progress, start_date: fg_s_date, end_date: fg_e_date, type: 'milestone'})
    facility_projects.where(project_id: project_id).distinct.each do |facility|
      facility.gantt_hash(hash, fg_id)
    end
  end
end
