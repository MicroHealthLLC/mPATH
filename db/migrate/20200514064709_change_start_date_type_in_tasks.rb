class ChangeStartDateTypeInTasks < ActiveRecord::Migration[5.2]
  def change
    change_column :tasks, :start_date, :date
  end
end
