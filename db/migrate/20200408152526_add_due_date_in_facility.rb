class AddDueDateInFacility < ActiveRecord::Migration[5.2]
  def change
    add_column :facilities, :due_date, :date
  end
end
