class CreateContractNameCustomers < ActiveRecord::Migration[6.1]
  def change
    create_table :contract_name_customers do |t|
      t.string :name

      t.timestamps
    end
  end
end
