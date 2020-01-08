class ChangeTypeOfRegionBoundary < ActiveRecord::Migration[5.2]
  def change
    change_column :regions, :boundary, :text
  end
end
