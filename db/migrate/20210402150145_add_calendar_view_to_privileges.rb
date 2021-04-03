class AddCalendarViewToPrivileges < ActiveRecord::Migration[5.2]
  def change
    add_column :privileges, :calendar_view, :string, default: "R"
  end
end
