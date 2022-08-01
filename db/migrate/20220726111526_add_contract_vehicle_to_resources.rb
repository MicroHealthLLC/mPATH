class AddContractVehicleToResources < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :project_contract_vehicle_id, :integer
    add_column :issues, :project_contract_vehicle_id, :integer
    add_column :risks, :project_contract_vehicle_id, :integer
    add_column :lessons, :project_contract_vehicle_id, :integer
  end
end
