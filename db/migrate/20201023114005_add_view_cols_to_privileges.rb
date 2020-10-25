class AddViewColsToPrivileges < ActiveRecord::Migration[5.2]
  def change
    add_column :privileges, :map_view, :string, default: "R"
    add_column :privileges, :gantt_view, :string, default: "R"
    add_column :privileges, :watch_view, :string, default: "R"
    add_column :privileges, :documents, :string, default: "R"
    add_column :privileges, :members, :string, default: "R"
  end
end
