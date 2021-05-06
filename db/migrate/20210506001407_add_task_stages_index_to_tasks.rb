class AddTaskStagesIndexToTasks < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :task_stages_index, :integer
  end
end
