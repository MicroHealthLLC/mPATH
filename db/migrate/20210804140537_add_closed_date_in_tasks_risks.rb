class AddClosedDateInTasksRisks < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :closed_date, :date
    add_column :risks, :closed_date, :date
  end
end
