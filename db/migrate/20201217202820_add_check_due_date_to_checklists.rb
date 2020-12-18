class AddCheckDueDateToChecklists < ActiveRecord::Migration[5.2]
  def change
    add_column :checklists, :due_date, :date
  end
end
