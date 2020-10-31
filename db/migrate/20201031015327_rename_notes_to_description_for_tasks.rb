class RenameNotesToDescriptionForTasks < ActiveRecord::Migration[5.2]
  def change
    rename_column :tasks, :notes, :description
  end
end
