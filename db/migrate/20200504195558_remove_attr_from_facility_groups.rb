class RemoveAttrFromFacilityGroups < ActiveRecord::Migration[5.2]
  def change
    remove_column :facility_groups, :position
    remove_column :facility_groups, :boundary
    remove_column :facility_groups, :color
  end
end
