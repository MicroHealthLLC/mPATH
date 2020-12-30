class AddRiskNameToRisks < ActiveRecord::Migration[5.2]
  def change
    add_column :risks, :text, :string
  end
end
