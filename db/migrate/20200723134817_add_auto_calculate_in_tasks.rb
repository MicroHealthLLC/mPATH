class AddAutoCalculateInTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :auto_calculate, :boolean, default: true
    begin
      Task.update_all auto_calculate: false
    rescue
      nil
    end
  end
end
