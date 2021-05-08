class RemoveRiskStagesIndexFromRisk < ActiveRecord::Migration[6.1]
  def change
    remove_column :risks, :risk_stages_index, :integer
  end
end
