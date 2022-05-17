class CreateContractAgencies < ActiveRecord::Migration[6.1]
  def change
    create_table :contract_agencies do |t|
      t.string :name

      t.timestamps
    end
  end
end
