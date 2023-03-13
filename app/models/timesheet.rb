class Timesheet < ApplicationRecord
  # self.table_name = "efforts"
  belongs_to :resource, polymorphic: true
  belongs_to :user
  belongs_to :facility_project
  has_one :facility, through: :facility_project

  validates :date_of_week, presence: true
  validates :hours, presence: true, numericality: { greater_than_or_equal_to: 0 }

  after_create :update_acutal_effort_to_task
  after_update :update_acutal_effort_to_task

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
  def to_json(options = {})
    self.as_json.merge({"date_of_week" => self.date_of_week.strftime("%d %b %y")})
  end

  def update_acutal_effort_to_task
    resource.update_actual_effort
  end

  def create_or_update_timesheet(params, user)

    timesheet_params = params.require(:timesheet).permit(Timesheet.params_to_permit)

    timesheet = self
    t_params = timesheet_params.dup

    if t_params.has_key?(:facility_project_id)
      timesheet.facility_project_id = FacilityProject.find(t_params[:facility_project_id]).id
    else
      project = user.projects.active.find_by(id: params[:project_id])
      facility_project = project.facility_projects.find_by(facility_id: params[:facility_id])
      timesheet.facility_project_id = facility_project.id
    end
    
    if !t_params.has_key?(:task_id)
      timesheet.errors.add(:base, "Task must be provided to enter time.")
      return timesheet
    elsif !timesheet.facility_project.task_ids.include?(t_params[:task_id].to_i)
      timesheet.errors.add(:base, "Task must be part of project.")
      return timesheet
    else
      t_params[:resource_id] = t_params.delete(:task_id)
      t_params[:resource_type] = "Task"
    end
    timesheet.date_of_week = Date.parse(t_params.delete(:date_of_week) ) rescue nil 
    timesheet.attributes = t_params

    timesheet.transaction do
      timesheet.save
    end
    timesheet
    # timesheet.reload
  end

end
