class RemoveStatusToRisks < ActiveRecord::Migration[6.1]
  def change
    remove_column :risks, :status, :integer
  end
end
