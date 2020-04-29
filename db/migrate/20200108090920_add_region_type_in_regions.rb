class AddRegionTypeInRegions < ActiveRecord::Migration[5.2]
  def change
    add_column :facility_groups, :region_type, :integer, default: 0
  end
end
