class RemoveProjectsFromTasks < ActiveRecord::Migration[5.2]
  def change
    remove_column :tasks, :project_id
    add_reference :tasks, :facility, foreign_key: true
  end
end
