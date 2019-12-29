class AddRegionRefToFacility < ActiveRecord::Migration[5.2]
  def change
    add_reference :facilities, :region, index: true
  end
end
