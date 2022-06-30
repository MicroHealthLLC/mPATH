class AddFieldsToContractTables < ActiveRecord::Migration[6.1]
  def change
    add_column :contract_vehicles, :caf_fees, :decimal, precision: 4, scale: 2, default: 0.0

    add_column :contract_project_data, :notes, :text
  end
end
