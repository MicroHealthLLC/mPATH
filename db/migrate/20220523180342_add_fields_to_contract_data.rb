class AddFieldsToContractData < ActiveRecord::Migration[6.1]
  def change
    add_column :contract_project_data, :contract_vehicle_id, :integer
    add_column :contract_project_data, :contract_award_type_id, :integer
    add_column :contract_project_data, :user_id, :integer
  end
end
