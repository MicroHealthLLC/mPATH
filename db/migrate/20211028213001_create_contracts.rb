class CreateContracts < ActiveRecord::Migration[6.1]
  def change
    create_table :contracts do |t|
      t.bigint :contract_type_id, null: false, foreign_key: true
      t.integer :project_code
      t.string :contract_nickname
      t.belongs_to :contract_status, null: false, foreign_key: true
      t.belongs_to :contract_name_customer, null: false, foreign_key: true
      t.belongs_to :contract_vehicle, null: false, foreign_key: true
      t.belongs_to :contract_vehicle_number, null: false, foreign_key: true
      t.belongs_to :contract_number, null: false, foreign_key: true
      t.belongs_to :subcontract_number, null: false, foreign_key: true
      t.belongs_to :contract_prime, null: false, foreign_key: true
      t.datetime :start_date
      t.datetime :end_date
      t.belongs_to :contract_current_pop, null: false, foreign_key: true
      t.datetime :current_pop_start_time
      t.datetime :current_pop_end_time
      t.integer :days_remaining
      t.float :total_contract_value
      t.float :current_pop_value
      t.float :current_pop_funded
      t.float :total_contract_funded

      t.timestamps
    end
  end
end
