class AddIsDefaultToFacilityGroups < ActiveRecord::Migration[6.1]
  def change
    add_column :facility_groups, :owner_id, :integer
    add_column :facility_groups, :owner_type, :string
    add_column :project_facility_groups, :is_default, :boolean, default: false    
  end
end
