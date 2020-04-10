class UpdateFacilityInTasks < ActiveRecord::Migration[5.2]
  def change
    remove_column :tasks, :facility_id
    add_reference :tasks, :facility_project, foreign_key: true
  end
end
