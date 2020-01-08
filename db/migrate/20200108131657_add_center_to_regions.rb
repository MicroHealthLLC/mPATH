class AddCenterToRegions < ActiveRecord::Migration[5.2]
  def change
    add_column :regions, :center, :string
  end
end
