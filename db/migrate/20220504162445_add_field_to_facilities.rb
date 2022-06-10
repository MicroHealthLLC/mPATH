class AddFieldToFacilities < ActiveRecord::Migration[6.1]
  def change
    add_column :facilities, :is_portfolio, :boolean, default: true
  end
end
