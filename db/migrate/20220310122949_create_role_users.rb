class CreateRoleUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :role_users do |t|
      t.integer :role_id
      t.integer :user_id
      t.integer :project_id
      t.integer :contract_id
      t.integer :facility_id
      t.integer :facility_project_id

      t.timestamps
    end
  end
end
