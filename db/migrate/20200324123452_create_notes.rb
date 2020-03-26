class CreateNotes < ActiveRecord::Migration[5.2]
  def change
    create_table :notes do |t|
      t.string :noteable_type
      t.integer :noteable_id
      t.references :user
      t.text :body
      t.timestamps
    end
  end
end
