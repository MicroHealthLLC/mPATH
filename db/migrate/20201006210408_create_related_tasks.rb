class CreateRelatedTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :related_tasks do |t|
      t.string :relatable_type
      t.integer :relatable_id
      t.references :task, foreign_key: true
      t.timestamps
    end
  end
end
