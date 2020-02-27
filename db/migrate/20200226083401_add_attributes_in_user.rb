class AddAttributesInUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :title, :string
    add_column :users, :phone_number, :string
    add_column :users, :address, :string
    add_column :users, :role, :integer, default: 0
  end
end
