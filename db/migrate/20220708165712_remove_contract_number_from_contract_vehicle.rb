class RemoveContractNumberFromContractVehicle < ActiveRecord::Migration[6.1]
  def change
    remove_column :contract_vehicles, :contract_number
  end
end
