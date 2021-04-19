class CreateLessonUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :lesson_users do |t|
      t.integer :user_id, null: false
      t.integer :lesson_id, null: false

      t.timestamps
    end
    add_index :lesson_users, :user_id
    add_index :lesson_users, :lesson_id
  end
end
