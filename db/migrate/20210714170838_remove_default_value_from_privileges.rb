class RemoveDefaultValueFromPrivileges < ActiveRecord::Migration[6.1]
  def change

    change_column_default :privileges, :map_view, from: "R", to: nil
    change_column_default :privileges, :gantt_view, from: "R", to: nil
    change_column_default :privileges, :members, from: "R", to: nil
    change_column_default :privileges, :sheets_view, from: "R", to: nil
    change_column_default :privileges, :kanban_view, from: "R", to: nil
    change_column_default :privileges, :calendar_view, from: "R", to: nil
    change_column_default :privileges, :admin, from: "R", to: nil

    change_column_default :privileges, :overview, from: "R", to: nil
    change_column_default :privileges, :tasks, from: "R", to: nil
    change_column_default :privileges, :notes, from: "R", to: nil
    change_column_default :privileges, :issues, from: "R", to: nil
    change_column_default :privileges, :risks, from: "R", to: nil
    change_column_default :privileges, :watch_view, from: "R", to: nil
    change_column_default :privileges, :documents, from: "R", to: nil
    change_column_default :privileges, :facility_manager_view, from: "R", to: nil
    change_column_default :privileges, :lessons, from: "R", to: nil
    change_column_default :privileges, :portfolio_view, from: "R", to: nil

  end
end
