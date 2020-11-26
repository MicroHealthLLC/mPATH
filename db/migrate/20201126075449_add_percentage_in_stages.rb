class AddPercentageInStages < ActiveRecord::Migration[5.2]
  def change
    add_column :task_stages, :percentage, :integer, default: 0
    add_column :issue_stages, :percentage, :integer, default: 0
  end
end
