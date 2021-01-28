class AddProbabilityNameToRisks < ActiveRecord::Migration[5.2]
  def change
    add_column :risks, :probability_name, :string
  end
end
