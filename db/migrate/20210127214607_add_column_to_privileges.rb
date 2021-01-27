class AddColumnToPrivileges < ActiveRecord::Migration[5.2]
  def change
    add_column :privileges, :role_id, :integer
    add_index :privileges, :role_id
  end
end
