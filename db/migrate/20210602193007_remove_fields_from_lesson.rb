class RemoveFieldsFromLesson < ActiveRecord::Migration[6.1]
  def change
    remove_column :lessons, :task_id, :integer
    remove_column :lessons, :risk_id, :integer
    remove_column :lessons, :issue_id, :integer
    remove_column :lessons, :project_id, :integer
    remove_column :lessons, :issue_type_id, :integer

    drop_table :lesson_projects
  end
end
