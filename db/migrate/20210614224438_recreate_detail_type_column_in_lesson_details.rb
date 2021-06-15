class RecreateDetailTypeColumnInLessonDetails < ActiveRecord::Migration[6.1]
  def change
    remove_column :lesson_details, :detail_type
    add_column :lesson_details, :detail_type, :string, default: 'success'
  end
end
