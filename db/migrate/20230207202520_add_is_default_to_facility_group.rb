class AddIsDefaultToFacilityGroup < ActiveRecord::Migration[7.0]
  def change
    add_column :facility_groups, :is_default, :boolean, default: false
  end
end
