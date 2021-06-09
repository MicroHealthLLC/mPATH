class AddLessonStageToLessons < ActiveRecord::Migration[6.1]
  def change
    add_column :lessons, :lesson_stage_id, :integer
  end
end
