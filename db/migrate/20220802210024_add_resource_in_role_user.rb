class AddResourceInRoleUser < ActiveRecord::Migration[6.1]
  def change
    add_column :role_users, :resource_type, :string
    add_column :role_users, :resource_id, :integer
  end
end
