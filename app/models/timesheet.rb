class Timesheet < ApplicationRecord
  belongs_to :resource, polymorphic: true
  belongs_to :user
  belongs_to :facility_project

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

  def create_or_update_timesheet(params, user)

    timesheet_params = params.require(:timesheet).permit(Timesheet.params_to_permit)

    timesheet = self
    t_params = timesheet_params.dup

    if t_params.has_key?(:task_id)
      t_params[:resource_id] = t_params.delete(:task_id)
      t_params[:resource_type] = "Task"
    end
    timesheet.attributes = t_params 
    timesheet.transaction do
      timesheet.save!
    end
    timesheet.reload
  end
end
