class AddFacilityProjectIdsToFacilityPrivileges < ActiveRecord::Migration[6.1]
  def change
    add_column :facility_privileges, :facility_project_ids, :string, default: [].to_yaml
  end
end
