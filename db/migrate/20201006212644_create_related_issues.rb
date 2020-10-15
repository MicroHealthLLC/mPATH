class CreateRelatedIssues < ActiveRecord::Migration[5.2]
  def change
    create_table :related_issues do |t|
      t.string :relatable_type
      t.integer :relatable_id
      t.references :issue, foreign_key: true
      t.timestamps
    end
  end
end
