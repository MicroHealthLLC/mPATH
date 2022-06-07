class AddFacilityGroupIdToProjectContract < ActiveRecord::Migration[6.1]
  def change
    add_column :project_contracts, :facility_group_id, :integer
  end
end
