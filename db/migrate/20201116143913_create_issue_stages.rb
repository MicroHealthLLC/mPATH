class CreateIssueStages < ActiveRecord::Migration[5.2]
  def change
    create_table :issue_stages do |t|
      t.string :name, null: false
      t.timestamps
    end
    Sort.create(relation: 'issue_stages')
  end
end
