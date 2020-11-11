class AddSheetsViewInPrivileges < ActiveRecord::Migration[5.2]
  def change
    add_column :privileges, :sheets_view, :string, default: "R"
  end
end
