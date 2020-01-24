class RemoveReferenceFcailityFromProject < ActiveRecord::Migration[5.2]
  def change
    remove_column :projects, :facility_id
    add_reference :facilities, :project, foreign_key: true
  end
end
