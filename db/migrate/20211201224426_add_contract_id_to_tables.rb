class AddContractIdToTables < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :contract_id, :integer
    add_column :risks, :contract_id, :integer
    add_column :issues, :contract_id, :integer
    add_column :lessons, :contract_id, :integer
  end
end
