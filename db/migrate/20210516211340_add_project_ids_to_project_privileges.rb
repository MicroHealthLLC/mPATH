class AddProjectIdsToProjectPrivileges < ActiveRecord::Migration[6.1]
  def change
    add_column :project_privileges, :project_ids, :string, default: [].to_yaml
  end
end
