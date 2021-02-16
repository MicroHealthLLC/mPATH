class AddApprovalTimeToRisks < ActiveRecord::Migration[5.2]
  def change
    add_column :risks, :approval_time, :string
  end
end
