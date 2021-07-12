class AddGroupNumberFacilityPrivilege < ActiveRecord::Migration[6.1]
  def change
    add_column :facility_privileges, :group_number, :integer, default: 0
  end
end
