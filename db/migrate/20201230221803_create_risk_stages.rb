class CreateRiskStages < ActiveRecord::Migration[5.2]
  def change
    create_table :risk_stages do |t|
      t.string :name
      t.integer :percentage, default: 0

      t.timestamps
    end
  end
end
