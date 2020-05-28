class CreateIssueStatuses < ActiveRecord::Migration[5.2]
  def change
    create_table :issue_statuses do |t|
      t.string :name, null: false
      t.timestamps
    end
  end
end
