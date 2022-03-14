class CreateRolePrivileges < ActiveRecord::Migration[6.1]
  def change
    create_table :role_privileges do |t|
      t.integer :role_id, null: false
      t.string :name, null: false
      t.string :privilege
      t.string :role_type, null: false

      t.timestamps
    end
  end
end
