class AddSubdomainToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :subdomain, :string, default: 'mpath'
  end
end
