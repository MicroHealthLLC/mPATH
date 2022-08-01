class CreateProjectContractVehicles < ActiveRecord::Migration[6.1]
  def change
    create_table :project_contract_vehicles do |t|
      t.integer :project_id, null: false
      t.integer :contract_vehicle_id, null: false
      t.integer :user_id
      t.integer :facility_group_id

      t.timestamps
    end
  end
end
