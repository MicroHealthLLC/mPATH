class ChangeTypeOfRegionBoundary < ActiveRecord::Migration[5.2]
  def change
    change_column :facility_groups, :boundary, :text
  end
end
