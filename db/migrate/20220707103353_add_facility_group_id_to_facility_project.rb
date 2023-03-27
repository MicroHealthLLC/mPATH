class AddFacilityGroupIdToFacilityProject < ActiveRecord::Migration[6.1]
  def change
    add_column :facility_projects, :facility_group_id, :integer
    change_column_default :facility_groups, :is_portfolio, from: true, to: false
    change_column_default :facility_groups, :status, from: 0, to: 1

  end
end
