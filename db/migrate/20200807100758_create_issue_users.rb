class CreateIssueUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :issue_users do |t|
      t.references :user, foreign_key: true
      t.references :issue, foreign_key: true
      t.timestamps
    end
  end
end
