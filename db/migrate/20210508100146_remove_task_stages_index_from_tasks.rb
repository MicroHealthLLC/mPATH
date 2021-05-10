class RemoveTaskStagesIndexFromTasks < ActiveRecord::Migration[6.1]
  def change
    remove_column :tasks, :task_stages_index, :integer
  end
end
