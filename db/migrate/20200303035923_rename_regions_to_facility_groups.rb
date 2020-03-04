class RenameRegionsToFacilityGroups < ActiveRecord::Migration[5.2]
  def change
    rename_table :regions, :facility_groups
    rename_column :facilities, :region_id, :facility_group_id
    rename_column :region_states, :region_id, :facility_group_id
  end
end
