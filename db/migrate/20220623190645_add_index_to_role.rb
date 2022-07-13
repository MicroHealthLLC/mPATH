class AddIndexToRole < ActiveRecord::Migration[6.1]
  def change
    add_index :role_users, [ :facility_project_id, :project_contract_id ]
    add_index :role_users, [ :role_id, :user_id, :project_id ]
    add_index :roles, [:project_id, :user_id, :is_default ]
    add_index :role_privileges, [:role_id, :role_type ]
  end
end
