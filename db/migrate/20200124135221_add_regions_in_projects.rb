class AddRegionsInProjects < ActiveRecord::Migration[5.2]
  def change
    add_reference :regions, :project, foreign_key: true
  end
end
