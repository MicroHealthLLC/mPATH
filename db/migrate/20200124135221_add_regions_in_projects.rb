class AddRegionsInProjects < ActiveRecord::Migration[5.2]
  def change
    add_reference :facility_groups, :project, foreign_key: true
  end
end
