class ChangeTaskColumn < ActiveRecord::Migration[6.1]
  def down
    change_column :tasks, :planned_effort, :decimal, default: 0.0
    change_column :tasks, :actual_effort, :decimal, default: 0.0
  end
  def up
    change_column :tasks, :planned_effort, :decimal, default: 0.0, precision: 10, scale: 2
    change_column :tasks, :actual_effort, :decimal, default: 0.0, precision: 10, scale: 2
  end
end
