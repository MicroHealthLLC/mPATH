class RemoveRegionIdFromStates < ActiveRecord::Migration[5.2]
  def change
    remove_column :states, :facility_group_id
  end
end
