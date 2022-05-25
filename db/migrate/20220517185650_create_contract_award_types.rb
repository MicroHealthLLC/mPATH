class CreateContractAwardTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :contract_award_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
