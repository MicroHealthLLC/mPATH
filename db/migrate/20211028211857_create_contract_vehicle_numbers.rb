class CreateContractVehicleNumbers < ActiveRecord::Migration[6.1]
  def change
    create_table :contract_vehicle_numbers do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
