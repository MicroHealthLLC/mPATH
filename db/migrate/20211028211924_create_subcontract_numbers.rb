class CreateSubcontractNumbers < ActiveRecord::Migration[6.1]
  def change
    create_table :subcontract_numbers do |t|
      t.string :name

      t.timestamps
    end
  end
end
