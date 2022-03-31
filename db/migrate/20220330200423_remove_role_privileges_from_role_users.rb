class RemoveRolePrivilegesFromRoleUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :role_users, :role_privilege_id
    remove_column :role_users, :facility_id
  end
end
