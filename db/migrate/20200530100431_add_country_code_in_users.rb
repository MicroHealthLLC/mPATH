class AddCountryCodeInUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :country_code, :string, default: ""
  end
end
