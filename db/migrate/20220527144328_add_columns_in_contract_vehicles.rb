class AddColumnsInContractVehicles < ActiveRecord::Migration[6.1]
  def change
    if !column_exists?(:contract_vehicles,  :full_name)
      add_column :contract_vehicles,  :full_name, :string
    end

    if !column_exists?(:contract_vehicles, :contract_number)
      add_column :contract_vehicles, :contract_number, :string
    end

    if !column_exists?(:contract_vehicles, :ceiling)
       add_column :contract_vehicles, :ceiling, :string
    end

    if !column_exists?(:contract_vehicles, :base_period_start)
       add_column :contract_vehicles, :base_period_start, :datetime
    end

    if !column_exists?(:contract_vehicles, :base_period_end)
       add_column :contract_vehicles, :base_period_end, :datetime
    end

    if !column_exists?(:contract_vehicles, :option_period_start)
       add_column :contract_vehicles, :option_period_start, :datetime
    end

    if !column_exists?(:contract_vehicles, :option_period_end)
       add_column :contract_vehicles, :option_period_end, :datetime
    end

    if !column_exists?(:contract_vehicles, :contract_agency_id)
       add_column :contract_vehicles, :contract_agency_id, :integer
    end

    if !column_exists?(:contract_vehicles, :contract_vehicle_type_id)
      add_column :contract_vehicles, :contract_vehicle_type_id, :integer
    end

  end
end
