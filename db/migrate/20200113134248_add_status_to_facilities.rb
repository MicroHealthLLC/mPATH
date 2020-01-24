class AddStatusToFacilities < ActiveRecord::Migration[5.2]
  def change
    add_column :facilities, :status, :integer, default: 0
  end
end
