class AddContractNumberIdToTables < ActiveRecord::Migration[6.1]
  def change
    add_column :contract_vehicles, :contract_number_id, :integer
    add_column :contract_project_data, :contract_number_id, :integer
    add_column :contract_numbers, :user_id, :integer
  end
end
