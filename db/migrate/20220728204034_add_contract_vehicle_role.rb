class AddContractVehicleRole < ActiveRecord::Migration[6.1]
  def change
    add_column :role_users, :project_contract_vehicle_id, :integer
  end
end
