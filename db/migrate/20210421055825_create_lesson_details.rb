class CreateLessonDetails < ActiveRecord::Migration[6.1]
  def change
    create_table :lesson_details do |t|
      t.text :finding
      t.text :recommendation
      t.integer :user_id
      t.integer :lesson_id
      t.integer :detail_type
      
      t.timestamps
    end
  end
end
