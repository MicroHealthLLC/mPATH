class AddCenterToRegions < ActiveRecord::Migration[5.2]
  def change
    add_column :facility_groups, :center, :string, default: "[]"
  end
end
