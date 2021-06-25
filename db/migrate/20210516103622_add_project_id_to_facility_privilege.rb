class AddProjectIdToFacilityPrivilege < ActiveRecord::Migration[6.1]
  def change
    add_column :facility_privileges, :project_id, :integer
  end
end
