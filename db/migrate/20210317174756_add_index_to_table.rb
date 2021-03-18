class AddIndexToTable < ActiveRecord::Migration[5.2]
  def change
    add_index :tasks, :due_date
    add_index :notes, :created_at
    add_index :checklists, :position
    add_index :risks, :due_date

  end
end
