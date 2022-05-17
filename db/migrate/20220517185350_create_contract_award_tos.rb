class CreateContractAwardTos < ActiveRecord::Migration[6.1]
  def change
    create_table :contract_award_tos do |t|
      t.string :name

      t.timestamps
    end
  end
end
