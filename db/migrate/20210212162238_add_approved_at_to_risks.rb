class AddApprovedAtToRisks < ActiveRecord::Migration[5.2]
  def change
    add_column :risks, :approved_at, :datetime
  end
end
