class ChangeFieldDatatype < ActiveRecord::Migration[6.1]
  def change
    change_column :contract_vehicles, :ceiling, :decimal, precision: 19, scale: 4

    change_column :contract_project_data, :total_contract_value, :decimal, precision: 19, scale: 4
    change_column :contract_project_data, :total_founded_value, :decimal, precision: 19, scale: 4
    change_column :contract_project_data, :billings_to_date, :decimal, precision: 19, scale: 4

    change_column :contract_sub_categories, :name, :text

  end
end
