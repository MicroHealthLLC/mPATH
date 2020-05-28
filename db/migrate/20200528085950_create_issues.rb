class CreateIssues < ActiveRecord::Migration[5.2]
  def change
    create_table :issues do |t|
      t.string :title
      t.text :description
      t.references :issue_type, foreign_key: true
      t.references :issue_severity, foreign_key: true
      t.references :issue_status, foreign_key: true
      t.references :facility_project, foreign_key: true
      t.date :start_date
      t.date :due_date
      t.timestamps
    end
  end
end
