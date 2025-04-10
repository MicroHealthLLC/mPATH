class Effort < ApplicationRecord
  include CommonUtilities

  belongs_to :resource, polymorphic: true
  belongs_to :user
  belongs_to :facility_project
  has_one :facility, through: :facility_project

  validates :date_of_week, presence: true
  validates :hours, presence: true, numericality: { greater_than_or_equal_to: 0 }

  after_create :update_acutal_effort_to_task
  after_update :update_acutal_effort_to_task

  scope :not_projected_hours, lambda {where(projected: false)}
  scope :projected_hours, lambda {where(projected: true)}

  def self.params_to_permit
    [
      :hours,
      :user_id,
      :facility_project_id,
      :task_id,
      :date_of_week,
      :resource_id,
      :resource_type
    ]
  end

  def this_week_dates
    (Date.today.monday..(Date.today.monday + 4))
  end

  def projected_effort?
    self.date_of_week.to_date > this_week_dates.last
  end

  def as_json(options = {})
    self.to_json
  end

  def to_json(options = {})
    self.attributes.with_indifferent_access.merge({hours: strip_trailing_zero(self.hours),"date_of_week" => self.date_of_week.strftime("%d %b %y")})
  end

  def update_acutal_effort_to_task
    resource.update_actual_effort
  end

  def self.update_projected(options={})
    facility_project = nil
    effort_ids = []
    if options[:project_id] && options[:facility_id]
      facility_project = FacilityProject.where(project_id: options[:project_id], facility_id: options[:facility_id]).first
    end
    
    if facility_project
      effort_ids = Effort.where("date_of_week < ? and projected = ? and facility_project_id = ?", Date.today, true, facility_project.id ).pluck(:id)
    else
      effort_ids = Effort.where("date_of_week < ? and projected = ?", Date.today, true ).pluck(:id)
    end
    
    if effort_ids.any?
      Effort.where(id: effort_ids).update_all(projected: false)
      task_ids = Effort.where(id: effort_ids).pluck(:resource_id).uniq
      Task.where(id: task_ids).map(&:update_actual_effort)
    end
  end

  def create_or_update_effort(params, user)

    effort_params = params.require(:effort).permit(Effort.params_to_permit)

    effort = self
    t_params = effort_params.dup

    if t_params.has_key?(:facility_project_id)
      effort.facility_project_id = FacilityProject.find(params[:facility_project_id]).id
    else
      project = user.projects.active.find_by(id: params[:project_id])
      facility_project = project.facility_projects.find_by(facility_id: params[:facility_id])
      effort.facility_project_id = facility_project.id
    end
    
    if !t_params.has_key?(:task_id)
      effort.errors.add(:base, "Task must be provided to enter time.")
      return effort
    elsif !effort.facility_project.task_ids.include?(t_params[:task_id].to_i)
      effort.errors.add(:base, "Task must be part of project.")
      return effort
    else
      t_params[:resource_id] = t_params.delete(:task_id)
      t_params[:resource_type] = "Task"
    end
    effort.date_of_week = Date.parse(t_params.delete(:date_of_week) ) rescue nil 

    effort.attributes = t_params
    
    effort.projected = effort.date_of_week > this_week_dates.last

    effort.transaction do
      effort.save
    end
    effort
    # effort.reload
  end

end