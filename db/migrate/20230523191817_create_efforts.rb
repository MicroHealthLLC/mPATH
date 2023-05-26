class CreateEfforts < ActiveRecord::Migration[7.0]
  def change
    create_table :efforts, if_not_exists: true do |t|
      t.datetime :date_of_week, null: false
      t.decimal :hours, default: 0.0, precision: 4, scale: 2
      t.integer :user_id, null: false
      t.integer :resource_id, null: false
      t.integer :resource_type, null: false
      t.integer :facility_project_id, null: false
      t.boolean :projected, default: false

      t.timestamps
    end

    add_column :checklists, :planned_effort, :decimal, default: 0.0, precision: 10, scale: 2, if_not_exists: true
    add_column :tasks, :auto_calculate_planned_effort, :boolean, default: true, if_not_exists: true
    add_column :tasks, :planned_effort, :decimal, default: 0.0, precision: 10, scale: 2, if_not_exists: true
    add_column :tasks, :actual_effort, :decimal, default: 0.0, precision: 10, scale: 2, if_not_exists: true
  end
end
