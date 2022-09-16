class AddProgressToTables < ActiveRecord::Migration[6.1]
  def change
    add_column :project_contracts, :progress, :integer, default: 0
    add_column :project_contract_vehicles, :progeress, :integer, default: 0
  end
end
