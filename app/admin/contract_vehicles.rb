ActiveAdmin.register ContractVehicle do
  menu parent: "Contracts", priority: 1
  actions :all, except: [:show]

  breadcrumb do
    links = [link_to('Admin', admin_root_path), link_to('Contract Vehicles', admin_contract_vehicles_path)]
    if %(show edit).include?(params['action'])
      links << link_to(contract_vehicle.name, edit_admin_contract_vehicle_path)
    end
    links
  end
  
  permit_params do
    permitted = [:name]
    permitted
  end
end
