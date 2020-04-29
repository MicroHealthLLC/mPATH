class AddColumnsInRegion < ActiveRecord::Migration[5.2]
  def change
    add_column :facility_groups, :code, :string
    add_column :facility_groups, :status, :integer, default: 0
  end
end
