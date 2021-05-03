class CreateLessonDetails < ActiveRecord::Migration[6.1]
  def change
    create_table :lesson_details do |t|
      t.text :finding
      t.text :recommendation
      t.integer :user_id
      t.integer :lesson_id
      t.string :detail_type, default: 'success'
      
      t.timestamps
    end
  end
end
