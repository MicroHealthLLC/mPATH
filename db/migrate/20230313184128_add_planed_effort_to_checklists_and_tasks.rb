class AddPlanedEffortToChecklistsAndTasks < ActiveRecord::Migration[6.1]
  def change
    add_column :checklists, :planned_effort, :decimal, default: 0.0
    add_column :tasks, :auto_calculate_planned_effort, :boolean, default: true
  end
end
