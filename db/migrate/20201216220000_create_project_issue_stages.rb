class CreateProjectIssueStages < ActiveRecord::Migration[5.2]
  def change
    create_table :project_issue_stages do |t|
      t.integer :project_id
      t.integer :issue_stage_id

      t.timestamps
    end
  end
end
