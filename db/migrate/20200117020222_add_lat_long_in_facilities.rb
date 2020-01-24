class AddLatLongInFacilities < ActiveRecord::Migration[5.2]
  def change
    remove_column :facilities, :latlng
    add_column :facilities, :lat, :string
    add_column :facilities, :lng, :string
  end
end
