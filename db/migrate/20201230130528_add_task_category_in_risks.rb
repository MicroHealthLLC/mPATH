class AddTaskCategoryInRisks < ActiveRecord::Migration[5.2]
  def change
    remove_column :risks, :risk_milestone_id
    drop_table :risk_milestones
    add_reference :risks, :task_type, foreign_key: true
  end
end
