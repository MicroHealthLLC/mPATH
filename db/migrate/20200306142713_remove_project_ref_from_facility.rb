class RemoveProjectRefFromFacility < ActiveRecord::Migration[5.2]
  def change
    remove_column :facilities, :project_id
  end
end
