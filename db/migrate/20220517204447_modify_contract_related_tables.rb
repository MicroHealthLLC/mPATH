class ModifyContractRelatedTables < ActiveRecord::Migration[6.1]
  def change
    remove_column :contract_vehicles, :sins
    add_column :contract_vehicles, :conctract_sub_category_id, :integer
    
    remove_column :contract_vehicles, :contract_agency
    add_column :contract_vehicles, :contract_agency_id, :integer

    remove_column :contract_vehicles, :vehicle_type
    add_column :contract_vehicles, :vehicle_type_id, :integer
    
  end
end
