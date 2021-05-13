class CreateProjectPrivileges < ActiveRecord::Migration[6.1]
  def change
    create_table :project_privileges do |t|
      t.string :overview, default: ["R"].to_yaml
      t.string :tasks, default: ["R"].to_yaml
      t.string :notes, default: ["R"].to_yaml
      t.string :issues, default: ["R"].to_yaml
      t.string :admin
      t.string :risks, default: ["R"].to_yaml
      t.string :lessons, default: ["R"].to_yaml
      t.integer :user_id
      t.integer :project_id

      t.timestamps
    end
  end
end
