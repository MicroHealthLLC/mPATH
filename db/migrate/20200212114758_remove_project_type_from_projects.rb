class RemoveProjectTypeFromProjects < ActiveRecord::Migration[5.2]
  def change
    remove_column :projects, :project_type
  end
end
