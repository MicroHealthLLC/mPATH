ActiveAdmin.register ContractVehicleNumber do
  menu parent: "Contracts", priority: 1
  actions :all, except: [:show]

  breadcrumb do
    links = [link_to('Admin', admin_root_path), link_to('Contract Vehicle Numbers', admin_contract_vehicle_numbers_path)]
    if %(show edit).include?(params['action'])
      links << link_to(contract_vehicle_number.name, edit_admin_contract_vehicle_number_path)
    end
    links
  end

  permit_params do
    permitted = [:name]
    permitted
  end
end