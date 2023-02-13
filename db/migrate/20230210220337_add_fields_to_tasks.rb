class AddFieldsToTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :planned_effort, :decimal, default: 0.0
    add_column :tasks, :actual_effort, :decimal, default: 0.0
  end
end
