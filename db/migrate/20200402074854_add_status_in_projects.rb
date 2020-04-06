class AddStatusInProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :status, :integer, default: 1
  end
end
