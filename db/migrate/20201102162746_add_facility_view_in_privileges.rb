class AddFacilityViewInPrivileges < ActiveRecord::Migration[5.2]
  def change
    add_column :privileges, :facility_manager_view, :string, default: "R"
  end
end
