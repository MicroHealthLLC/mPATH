class CreateStates < ActiveRecord::Migration[5.2]
  def change
    create_table :states do |t|
      t.string :name
      t.string :code
      t.string :center, default: "[]"
      t.references :region, foreign_key: true
      t.timestamps
    end
  end
end
