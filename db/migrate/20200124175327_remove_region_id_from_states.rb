class RemoveRegionIdFromStates < ActiveRecord::Migration[5.2]
  def change
    remove_column :states, :region_id
  end
end
