class RemoveProjectFromRegions < ActiveRecord::Migration[5.2]
  def change
    remove_column :regions, :project_id
  end
end
