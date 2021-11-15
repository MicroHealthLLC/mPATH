class ChangeContractNameCustomerTableName < ActiveRecord::Migration[6.1]
  def change
    rename_table :contract_name_customers, :contract_customers
  end
end
