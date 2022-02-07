class CreateProjectFacilityGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :project_facility_groups do |t|
      t.integer :project_id, null: false
      t.integer :facility_group_id, null: false

      t.timestamps
    end
  end
end
