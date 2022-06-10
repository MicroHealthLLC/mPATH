class AddContractsToProjectPrivileges < ActiveRecord::Migration[6.1]
  def change
    add_column :project_privileges, :contracts, :string
  end
end
