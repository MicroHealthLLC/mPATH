class AddFieldsToResources < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :project_contract_id, :integer
    add_column :issues, :project_contract_id, :integer
    add_column :risks, :project_contract_id, :integer
    add_column :lessons, :project_contract_id, :integer
    rename_column :project_contracts, :contract_id, :contract_project_datum_id
  end
end
