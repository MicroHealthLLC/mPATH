class RemoveStatusFieldInTables < ActiveRecord::Migration[6.1]
  def change
    remove_column :risks, :state, :integer
    remove_column :tasks, :status, :integer
    remove_column :issues, :status, :integer
  end
end
