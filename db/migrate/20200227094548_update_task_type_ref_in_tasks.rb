class UpdateTaskTypeRefInTasks < ActiveRecord::Migration[5.2]
  def change
    remove_column :tasks, :task_type
    add_reference :tasks, :task_type, foreign_key: true
  end
end
