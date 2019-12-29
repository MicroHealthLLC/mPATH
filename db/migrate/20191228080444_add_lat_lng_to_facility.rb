class AddLatLngToFacility < ActiveRecord::Migration[5.2]
  def change
    add_column :facilities, :latlng, :string
  end
end
