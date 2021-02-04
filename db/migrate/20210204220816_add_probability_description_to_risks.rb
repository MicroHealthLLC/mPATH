class AddProbabilityDescriptionToRisks < ActiveRecord::Migration[5.2]
  def change
    add_column :risks, :probability_description, :text
  end
end
