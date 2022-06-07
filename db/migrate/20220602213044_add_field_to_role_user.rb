class AddFieldToRoleUser < ActiveRecord::Migration[6.1]
  def change
    add_column :role_users, :project_contract_id, :integer
    remove_column :role_users, :contract_id
  end
end
