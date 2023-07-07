class ChangeChecklistColumn < ActiveRecord::Migration[6.1]
  def down
    change_column :checklists, :planned_effort, :decimal, default: 0.0
  end
  def up
    change_column :checklists, :planned_effort, :decimal, default: 0.0, precision: 10, scale: 2
  end
end
