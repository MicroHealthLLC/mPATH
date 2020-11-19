class CreateTaskStages < ActiveRecord::Migration[5.2]
  def change
    create_table :task_stages do |t|
      t.string :name, null: false
      t.timestamps
    end
    Sort.create(relation: 'task_stages')
  end
end
