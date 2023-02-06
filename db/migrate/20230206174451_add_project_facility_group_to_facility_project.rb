class AddProjectFacilityGroupToFacilityProject < ActiveRecord::Migration[7.0]
  def change
    add_column :facility_projects, :project_facility_group_id, :integer
  end
end
