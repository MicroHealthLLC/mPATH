class AddApprovedToRisks < ActiveRecord::Migration[5.2]
  def change
    add_column :risks, :approved, :boolean
  end
end
