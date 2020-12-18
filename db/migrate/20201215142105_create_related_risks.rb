class CreateRelatedRisks < ActiveRecord::Migration[5.2]
  def change
    create_table :related_risks do |t|
      t.string :relatable_type
      t.integer :relatable_id
      t.references :risk, foreign_key: true
      t.timestamps
    end
  end
end
