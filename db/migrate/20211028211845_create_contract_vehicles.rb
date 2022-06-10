class CreateContractVehicles < ActiveRecord::Migration[6.1]
  def change
    create_table :contract_vehicles do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
