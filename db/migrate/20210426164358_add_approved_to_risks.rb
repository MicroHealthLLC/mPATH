class AddApprovedToRisks < ActiveRecord::Migration[6.1]
  def change
    add_column :risks, :approved, :boolean
  end
end
