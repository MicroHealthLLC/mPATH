class AddFieldsToProgramPrivileges < ActiveRecord::Migration[6.1]
  def change
    add_column :project_privileges, :cn_overview, :string, default: [].to_yaml
    add_column :project_privileges, :cn_tasks, :string, default: [].to_yaml
    add_column :project_privileges, :cn_notes, :string, default: [].to_yaml
    add_column :project_privileges, :cn_issues, :string, default: [].to_yaml
    add_column :project_privileges, :cn_risks, :string, default: [].to_yaml
    add_column :project_privileges, :cn_lessons, :string, default: [].to_yaml
  end
end
