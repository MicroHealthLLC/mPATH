class AddFieldsToFacilityProject < ActiveRecord::Migration[5.2]
  def change
    add_column :facility_projects, :progress, :integer, default: 0


    add_column :facility_projects, :color, :string, default: '#ff0000'

    add_column :projects, :progress, :integer, default: 0
    add_column :facility_groups, :progress, :integer, default: 0
    add_column :task_types, :progress, :integer, default: 0
    
  end
end
