class CreateProgressLists < ActiveRecord::Migration[5.2]
  def change
    create_table :progress_lists do |t|
      t.text :body
      t.integer :user_id
      t.integer :checklist_id

      t.timestamps
    end
  end
end
