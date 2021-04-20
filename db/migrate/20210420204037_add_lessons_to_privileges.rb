class AddLessonsToPrivileges < ActiveRecord::Migration[6.1]
  def change
    add_column :privileges, :lessons, :string, default: "R"
  end
end
