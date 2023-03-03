class Effort < ApplicationRecord
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
    effort.attributes = t_params

    effort.transaction do
      effort.save
    end
    effort
    # effort.reload
  end

end
