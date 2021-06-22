class AddUserTypeToLessonUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :lesson_users, :user_type, :string, default: "responsible"
  end
end
