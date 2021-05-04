class CreateProjectLessonStages < ActiveRecord::Migration[6.1]
  def change
    create_table :project_lesson_stages do |t|
      t.integer :project_id
      t.integer :lesson_stage_id

      t.timestamps
    end
  end
end
