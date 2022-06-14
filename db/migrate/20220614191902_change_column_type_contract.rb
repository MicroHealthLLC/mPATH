class ChangeColumnTypeContract < ActiveRecord::Migration[6.1]
  def up
    change_column :contract_project_data, :total_contract_value, :decimal, precision: 10, scale: 5, default: 0.0
    change_column :contract_project_data, :total_founded_value, :decimal, precision: 10, scale: 5, default: 0.0
    change_column :contract_project_data, :billings_to_date, :decimal, precision: 10, scale: 5, default: 0.0
  end

  def down
    change_column :contract_project_data, :total_contract_value, :decimal, precision: 10, scale: 5, default: 0.0
    change_column :contract_project_data, :total_founded_value, :decimal, precision: 10, scale: 5, default: 0.0
    change_column :contract_project_data, :billings_to_date, :decimal, precision: 10, scale: 5, default: 0.0
  end

end
