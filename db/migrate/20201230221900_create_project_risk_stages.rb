class CreateProjectRiskStages < ActiveRecord::Migration[5.2]
  def change
    create_table :project_risk_stages do |t|
      t.integer :project_id
      t.integer :risk_stage_id

      t.timestamps
    end
  end
end
