class AddKanbanOrderInTaskIssues < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :kanban_order, :integer, default: 0
    add_column :issues, :kanban_order, :integer, default: 0

    begin
      FacilityProject.find_each do |facility_project|
        facility_project.tasks.each do |task|
          task.init_kanban_order
          task.save
        end

        facility_project.issues.each do |issue|
          issue.init_kanban_order
          issue.save
        end
      end
    rescue
    end
  end
end
