class RemoveProjectIdFromFacilityGroups < ActiveRecord::Migration[6.1]
  def up
    # remove_column :facility_groups, :project_id
    add_column :facilities, :project_facility_group_id, :integer
  end
  def down
    remove_column :facilities, :project_facility_group_id
    # add_column :facility_groups, :project_id, :integer
  end
end
