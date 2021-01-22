class AddImpactLevelNameToRisks < ActiveRecord::Migration[5.2]
  def change
    add_column :risks, :impact_level_name, :string
  end
end
