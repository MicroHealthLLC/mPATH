class AddTaskTypeToIssues < ActiveRecord::Migration[5.2]
  def change
    add_column :issues, :task_type_id, :integer
  end
end
