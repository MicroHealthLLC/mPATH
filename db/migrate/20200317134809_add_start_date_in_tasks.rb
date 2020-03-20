class AddStartDateInTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :start_date, :datetime
  end
end
