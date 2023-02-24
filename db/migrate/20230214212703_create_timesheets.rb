
class CreateTimesheets < ActiveRecord::Migration[6.1]
  def change
    create_table :timesheets do |t|
      t.datetime :date_of_week, null: false
      t.decimal :hours, default: 0.0, precision: 4, scale: 2
      t.integer :user_id, null: false
      t.integer :resource_id, null: false
      t.string :resource_type, null: false
      t.integer :facility_project_id, null: false

      t.timestamps
    end
  end
end