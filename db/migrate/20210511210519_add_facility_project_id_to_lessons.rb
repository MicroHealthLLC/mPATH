class AddFacilityProjectIdToLessons < ActiveRecord::Migration[6.1]
  def change
    add_column :lessons, :facility_project_id, :integer
    add_index :lessons, :facility_project_id
    add_index :lessons, :task_type_id
    add_index :lessons, :task_id
    add_index :lessons, :risk_id
    add_index :lessons, :issue_id
    add_index :lessons, :issue_type_id
    add_index :lessons, :user_id
    add_index :lessons, :lesson_stage_id
  end
end
