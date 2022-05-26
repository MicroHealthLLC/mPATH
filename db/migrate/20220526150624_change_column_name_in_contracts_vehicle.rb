class ChangeColumnNameInContractsVehicle < ActiveRecord::Migration[6.1]
  def change
    rename_column :contract_vehicles, :vehicle_type_id, :contract_vehicle_type_id
    change_column :contract_project_data, :billings_to_date, :decimal
    add_column :contract_vehicles, :user_id, :integer
    add_column :contract_project_pocs, :user_id, :integer
    add_column :contract_customers, :user_id, :integer
    add_column :project_contracts, :user_id, :integer
    add_column :contract_award_tos, :user_id, :integer
    add_column :contract_naics, :user_id, :integer
    add_column :contract_award_types, :user_id, :integer
    add_column :contract_types, :user_id, :integer
    add_column :contract_current_pops, :user_id, :integer
    add_column :contract_pops, :user_id, :integer
  end
end
