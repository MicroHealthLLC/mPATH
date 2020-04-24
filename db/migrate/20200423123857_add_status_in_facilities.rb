class AddStatusInFacilities < ActiveRecord::Migration[5.2]
  def change
    add_column :facilities, :status, :integer, default: 1
  end
end
