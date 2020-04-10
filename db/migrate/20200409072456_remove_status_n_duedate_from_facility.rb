class RemoveStatusNDuedateFromFacility < ActiveRecord::Migration[5.2]
  def change
    remove_column :facilities, :notes
    remove_column :facilities, :status_id
    remove_column :facilities, :due_date
  end
end
