class CreateContracts < ActiveRecord::Migration[6.1]
  def change
    create_table :contracts do |t|
      t.bigint :contract_type_id, null: false, foreign_key: true
      t.integer :project_code
      t.string :contract_nickname
      t.bigint :contract_status_id, null: true, foreign_key: true
      t.bigint :contract_name_customer_id, null: true, foreign_key: true
      t.bigint :contract_vehicle_id, null: true, foreign_key: true
      t.bigint :contract_vehicle_number_id, null: true, foreign_key: true
      t.bigint :contract_number_id, null: true, foreign_key: true
      t.bigint :contract_classification_id, null: true, foreign_key: true
      t.bigint :subcontract_number_id, null: true, foreign_key: true
      t.bigint :contract_prime_id, null: true, foreign_key: true
      t.datetime :start_date
      t.datetime :end_date
      t.bigint :contract_current_pop_id, null: true, foreign_key: true
      t.datetime :current_pop_start_time
      t.datetime :current_pop_end_time
      t.integer :days_remaining
      t.float :total_contract_value
      t.float :current_pop_value
      t.float :current_pop_funded
      t.float :total_contract_funded
      t.bigint :user_id, null: false, foreign_key: true
      
      t.timestamps
    end
  end
end
