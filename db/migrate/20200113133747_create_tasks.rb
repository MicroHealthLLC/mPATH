class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.string :text
      t.integer :task_type
      t.text :notes
      t.date :due_date, default: nil
      t.references :project, foreign_key: true
      t.timestamps
    end
  end
end
