class DropIssueStatuses < ActiveRecord::Migration[5.2]
  def change
    remove_column :issues, :issue_status_id
    add_column :issues, :progress, :integer, default: 0
    drop_table :issue_statuses
  end
end
