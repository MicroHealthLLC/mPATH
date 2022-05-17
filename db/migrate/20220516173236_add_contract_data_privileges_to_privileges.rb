class AddContractDataPrivilegesToPrivileges < ActiveRecord::Migration[6.1]
  def change
    add_column :privileges, :contract_data, :string
  end
end
