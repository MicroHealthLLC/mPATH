class UpdateStatusRefInProjects < ActiveRecord::Migration[5.2]
  def change
    remove_column :projects, :status
    add_reference :projects, :status, foreign_key: true
  end
end
