class AddStagesInTaskAndIssues < ActiveRecord::Migration[5.2]
  def change
    add_reference :tasks, :task_stage, foreign_key: true
    add_reference :issues, :issue_stage, foreign_key: true
  end
end
