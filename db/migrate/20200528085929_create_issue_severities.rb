class CreateIssueSeverities < ActiveRecord::Migration[5.2]
  def change
    create_table :issue_severities do |t|
      t.string :name, null: false
      t.timestamps
    end
  end
end
