class ChangeDefaultValueOfPrivileges < ActiveRecord::Migration[6.1]
  def change
    change_column_default :facility_privileges, :overview, from: "R", to: ["R"].to_yaml
    change_column_default :facility_privileges, :tasks, from: "R", to: ["R"].to_yaml
    change_column_default :facility_privileges, :notes, from: "R", to: ["R"].to_yaml
    change_column_default :facility_privileges, :issues, from: "R", to: ["R"].to_yaml
    change_column_default :facility_privileges, :admin, from: "R", to: ["R"].to_yaml
    change_column_default :facility_privileges, :risks, from: "R", to: ["R"].to_yaml
  end
end
