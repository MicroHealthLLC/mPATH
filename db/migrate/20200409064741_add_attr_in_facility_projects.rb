class AddAttrInFacilityProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :facility_projects, :due_date, :date
    add_reference :facility_projects, :status, foreign_key: true
  end
end
