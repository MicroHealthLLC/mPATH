class CreateContractNaics < ActiveRecord::Migration[6.1]
  def change
    create_table :contract_naics do |t|
      t.string :name

      t.timestamps
    end
  end
end
