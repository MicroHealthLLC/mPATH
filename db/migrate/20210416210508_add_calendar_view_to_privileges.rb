class AddCalendarViewToPrivileges < ActiveRecord::Migration[6.1]
  def change
    add_column :privileges, :calendar_view, :string, default: "R"
  end
end
