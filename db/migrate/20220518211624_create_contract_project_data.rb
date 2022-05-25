class CreateContractProjectData < ActiveRecord::Migration[6.1]
  def change
    create_table :contract_project_data do |t|
      t.string :charge_code
      t.string :name
      t.integer :contract_customer_id
      t.integer :contract_award_to_id
      t.integer :contract_type_id
      t.string :prime_or_sub
      t.datetime :contract_start_date
      t.datetime :contract_end_date
      t.integer :total_contract_value
      t.integer :contract_pops
      t.integer :contract_current_pop_id
      t.datetime :contract_current_pop_start_date
      t.datetime :contract_current_pop_end_date
      t.decimal :total_founded_value
      t.datetime :billings_to_date
      t.string :comments
      t.integer :pm_contract_poc_id
      t.integer :gov_contract_poc_id
      t.integer :co_contract_poc_id


      t.timestamps
    end
  end
end
