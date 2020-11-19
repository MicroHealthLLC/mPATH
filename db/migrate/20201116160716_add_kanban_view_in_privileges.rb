class AddKanbanViewInPrivileges < ActiveRecord::Migration[5.2]
  def change
    add_column :privileges, :kanban_view, :string, default: "R"
  end
end
