class AddStatusToTasksRisksIssues < ActiveRecord::Migration[6.1]
  def change
    add_column :risks, :state, :integer
    add_column :tasks, :status, :integer
    add_column :issues, :status, :integer
  end
end
