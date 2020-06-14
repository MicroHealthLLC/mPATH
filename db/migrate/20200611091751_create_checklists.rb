class CreateChecklists < ActiveRecord::Migration[5.2]
  def change
    create_table :checklists do |t|
      t.string :listable_type
      t.integer :listable_id
      t.boolean :checked
      t.string :text
      t.timestamps
    end
  end
end
