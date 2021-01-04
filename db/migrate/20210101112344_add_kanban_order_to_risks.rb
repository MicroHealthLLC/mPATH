class AddKanbanOrderToRisks < ActiveRecord::Migration[5.2]
  def change
    add_column :risks, :kanban_order, :integer, default: 0
    add_reference :risks, :risk_stage, foreign_key: true

    begin
      FacilityProject.find_each do |facility_project|
        facility_project.risks.each do |risk|
          risk.init_kanban_order
          risk.save
        end
      end
    rescue
    end
  end
end
