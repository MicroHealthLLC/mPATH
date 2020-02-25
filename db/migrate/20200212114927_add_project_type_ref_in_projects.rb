class AddProjectTypeRefInProjects < ActiveRecord::Migration[5.2]
  def change
    add_reference :projects, :project_type, foreign_key: true
  end
end
