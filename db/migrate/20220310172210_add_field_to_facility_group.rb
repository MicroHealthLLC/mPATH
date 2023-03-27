class AddFieldToFacilityGroup < ActiveRecord::Migration[6.1]
  def change
    add_column :facility_groups, :is_portfolio, :boolean, default: true
    add_column :facility_groups, :user_id, :integer
  end
end
