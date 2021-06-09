class CreateLessonStages < ActiveRecord::Migration[6.1]
  def change
    create_table :lesson_stages do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
