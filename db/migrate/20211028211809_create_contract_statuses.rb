class CreateContractStatuses < ActiveRecord::Migration[6.1]
  def change
    create_table :contract_statuses do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
