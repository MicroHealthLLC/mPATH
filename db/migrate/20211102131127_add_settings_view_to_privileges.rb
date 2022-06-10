class AddSettingsViewToPrivileges < ActiveRecord::Migration[6.1]
  def change
    add_column :privileges, :settings_view, :string, default: "R"
  end
end
