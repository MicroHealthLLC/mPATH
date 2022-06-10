class RenameNotesToRemarksInContractsTable < ActiveRecord::Migration[6.1]
  def change
    rename_column :contracts, :notes, :remarks
  end
end
