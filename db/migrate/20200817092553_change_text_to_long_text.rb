class ChangeTextToLongText < ActiveRecord::Migration[5.2]
  def up
    change_column :issues, :description, :longtext
    change_column :projects, :description, :longtext
    change_column :tasks, :notes, :longtext
    change_column :notes, :body, :longtext
  end

  def down
    change_column :issues, :description, :text
    change_column :projects, :description, :text
    change_column :tasks, :notes, :text
    change_column :notes, :body, :text
  end
end
