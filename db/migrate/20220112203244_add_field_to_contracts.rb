class AddFieldToContracts < ActiveRecord::Migration[6.1]
  def change
    add_column :contracts, :total_subcontracts, :integer, default: 0
    add_column :contracts, :contract_category_id, :integer
    add_column :contracts, :contract_client_type_id, :integer
    add_column :contracts, :notes, :text
  end
end
