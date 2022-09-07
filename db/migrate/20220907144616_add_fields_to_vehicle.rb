class AddFieldsToVehicle < ActiveRecord::Migration[6.1]
  def change
    add_column :contract_vehicles, :subprime_name, :text
    add_column :contract_vehicles, :prime_name, :text
    add_column :contract_vehicles, :contract_name, :text
    add_column :contract_vehicles, :is_subprime, :boolean, default: false
    change_column :contract_vehicles, :full_name, :text
  end
end
