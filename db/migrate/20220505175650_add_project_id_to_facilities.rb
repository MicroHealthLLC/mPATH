class AddProjectIdToFacilities < ActiveRecord::Migration[6.1]
  def change
    add_column :facilities, :project_id, :integer
    add_index :facilities, :project_id
    add_index :facilities, :is_portfolio
  end
end
