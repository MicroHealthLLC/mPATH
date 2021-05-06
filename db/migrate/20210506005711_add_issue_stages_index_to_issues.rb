class AddIssueStagesIndexToIssues < ActiveRecord::Migration[6.1]
  def change
    add_column :issues, :issue_stages_index, :integer
  end
end
