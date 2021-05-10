class AddRiskStagesIndexToRisk < ActiveRecord::Migration[6.1]
  def change
    add_column :risks, :risk_stages_index, :integer
  end
end
