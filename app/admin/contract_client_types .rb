ActiveAdmin.register ContractClientType do
  menu parent: "Contracts", priority: 1
  actions :all, except: [:show]

  breadcrumb do
    links = [link_to('Admin', admin_root_path), link_to('Contract Client Types', admin_contract_client_types_path)]
    if %(show edit).include?(params['action'])
      links << link_to(contract_client_type.name, edit_admin_contract_client_type_path)
    end
    links
  end
  
  permit_params do
    permitted = [:name]
    permitted
  end

end
