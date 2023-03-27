class ModifyContractRelatedTables < ActiveRecord::Migration[6.1]
  def change
    if column_exists?  :contract_vehicles, :sins
      remove_column :contract_vehicles, :sins
    end
    add_column :contract_vehicles, :contract_sub_category_id, :integer
    
    if column_exists?  :contract_vehicles, :contract_agency
      remove_column :contract_vehicles, :contract_agency
    end
    add_column :contract_vehicles, :contract_agency_id, :integer

    if column_exists?  :contract_vehicles, :vehicle_type
      remove_column :contract_vehicles, :vehicle_type
    end
    add_column :contract_vehicles, :vehicle_type_id, :integer
    
  end
end
