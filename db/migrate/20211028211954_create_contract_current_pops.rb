class CreateContractCurrentPops < ActiveRecord::Migration[6.1]
  def change
    create_table :contract_current_pops do |t|
      t.string :name

      t.timestamps
    end
  end
end
