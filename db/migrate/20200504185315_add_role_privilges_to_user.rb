class AddRolePrivilgesToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :privileges, :string, default: ""
  end
end
