class CreateRisks < ActiveRecord::Migration[5.2]
  def change
    create_table :risks do |t|
      t.text        :risk_description
      t.text        :impact_description
      t.date        :start_date
      t.date        :due_date
      t.boolean     :auto_calculate, default: true
      t.integer     :progress, default: 0
      t.integer     :probability, default: 1
      t.integer     :impact_level, default: 1
      t.integer     :priority_level, default: 1
      t.integer     :risk_approach, default: 0
      t.text        :risk_approach_description
      t.boolean     :watched, default: false
      t.datetime    :watched_at
      t.references  :user, foreign_key: true
      t.references  :facility_project, foreign_key: true
      t.references  :risk_milestone, foreign_key: true
      t.timestamps
    end

    add_column :privileges, :risks, :string, default: "R"
  end
end
