class AddCountryCodeInFacilityContact < ActiveRecord::Migration[5.2]
  def change
    add_column :facilities, :country_code, :string, default: ""
  end
end
