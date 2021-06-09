class CreateLessons < ActiveRecord::Migration[6.1]
  def change
    create_table :lessons do |t|
      t.string :title
      t.text :description
      t.datetime :date
      t.string :stage
      t.integer :task_type_id
      t.integer :task_id
      t.integer :risk_id
      t.integer :issue_id
      t.integer :issue_type_id
      t.integer :user_id
      t.integer :project_id

      t.timestamps
    end
  end
end
