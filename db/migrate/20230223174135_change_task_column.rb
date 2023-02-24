class ChangeTaskColumn < ActiveRecord::Migration[6.1]
  def change
    change_column :tasks, :planned_effort, :decimal, default: 0.0, precision: 4, scale: 2
    change_column :tasks, :actual_effort, :decimal, default: 0.0, precision: 4, scale: 2
  end
end
