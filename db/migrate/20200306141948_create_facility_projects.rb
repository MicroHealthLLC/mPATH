class CreateFacilityProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :facility_projects do |t|
      t.references :facility, foreign_key: true
      t.references :project, foreign_key: true
      t.timestamps
    end
    Facility.all.each do |facility|
      FacilityProject.create(facility: facility, project_id: facility.project_id)
    end
  end
end
