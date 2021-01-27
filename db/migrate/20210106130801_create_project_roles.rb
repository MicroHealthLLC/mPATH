class CreateProjectRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :project_roles, force: true do |t|
      t.integer :role_id, foreign_key: true
      t.integer :project_id, foreign_key: true
      t.timestamps
    end
  end
end
