class AddLinksToLesson < ActiveRecord::Migration[6.1]
  def change
    add_column :lessons, :links, :string
    add_column :issues, :links, :string
    add_column :tasks, :links, :string
    add_column :risks, :links, :string
  end
end
