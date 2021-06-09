class CreateLessonProjects < ActiveRecord::Migration[6.1]
  def change
    create_table :lesson_projects do |t|
      t.integer :lesson_id
      t.integer :facility_project_id

      t.timestamps
    end
  end
end
