class CreateRiskMilestones < ActiveRecord::Migration[5.2]
  def change
    create_table :risk_milestones do |t|
      t.string :name, null: false
      t.timestamps
    end
    Sort.create(relation: 'risk_milestones')
  end
end
