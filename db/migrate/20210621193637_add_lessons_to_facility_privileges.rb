class AddLessonsToFacilityPrivileges < ActiveRecord::Migration[6.1]
  def change
    add_column :facility_privileges, :lessons, :string, default: ["R"].to_yaml
  end
end
