class ModifyContractFields < ActiveRecord::Migration[6.1]
  def change
    rename_column :contracts, :contract_name_customer_id, :contract_customer_id
    rename_column :contracts, :contract_nickname, :nickname
    add_column :contracts, :name, :string
  end
end
