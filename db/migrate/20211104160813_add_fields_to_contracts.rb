class AddFieldsToContracts < ActiveRecord::Migration[6.1]
  def change
    add_reference :contracts, :facility_group, index: true
    add_foreign_key :contracts, :facility_groups
    add_reference :contracts, :project, index: true
    add_foreign_key :contracts, :projects
  end
end
