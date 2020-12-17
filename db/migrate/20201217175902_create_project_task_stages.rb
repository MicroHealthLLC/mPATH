class CreateProjectTaskStages < ActiveRecord::Migration[5.2]
  def change
    create_table :project_task_stages do |t|
      t.integer :project_id
      t.integer :task_stage_id

      t.timestamps
    end
  end
end
