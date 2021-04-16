class RemoveCalendarFromPrivileges < ActiveRecord::Migration[6.1]
  def change
    remove_column :privileges, :calendar, :string
  end
end
