class CreateContractPocs < ActiveRecord::Migration[6.1]
  def change
    create_table :contract_pocs do |t|
      t.string :name

      t.timestamps
    end
  end
end
