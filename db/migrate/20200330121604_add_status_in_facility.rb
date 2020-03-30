class AddStatusInFacility < ActiveRecord::Migration[5.2]
  def change
    remove_column :facilities, :status
    remove_column :projects, :status_id
    add_reference :facilities, :status, foreign_key: true
  end
end
