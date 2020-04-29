class AddRegionRefToFacility < ActiveRecord::Migration[5.2]
  def change
    add_reference :facilities, :facility_group, index: true
  end
end
