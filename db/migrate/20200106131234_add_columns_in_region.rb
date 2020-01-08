class AddColumnsInRegion < ActiveRecord::Migration[5.2]
  def change
    add_column :regions, :code, :string
    add_column :regions, :status, :integer, default: 0
  end
end
