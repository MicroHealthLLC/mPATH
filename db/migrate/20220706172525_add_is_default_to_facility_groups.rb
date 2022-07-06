class AddIsDefaultToFacilityGroups < ActiveRecord::Migration[6.1]
  def change
    add_column :facility_groups, :is_default, :boolean, default: false
  end
end
