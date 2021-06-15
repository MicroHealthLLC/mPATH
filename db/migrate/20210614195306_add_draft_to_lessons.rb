class AddDraftToLessons < ActiveRecord::Migration[6.1]
  def change
    add_column :lessons, :draft, :boolean, default: false
  end
end
