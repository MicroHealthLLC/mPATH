class ChangeColumnName < ActiveRecord::Migration[6.1]
  def change
    rename_column :contract_vehicles, :conctract_sub_category_id, :contract_sub_category_id
    add_column :contract_project_data, :contract_naic_id, :integer
  end
end
