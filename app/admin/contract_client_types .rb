ActiveAdmin.register ContractClientType do
  menu parent: "Contracts", priority: 1
  actions :all, except: [:show]

  breadcrumb do
    links = [link_to('Admin', admin_root_path), link_to('Contract Classifications', admin_contract_classifications_path)]
    if %(show edit).include?(params['action'])
      links << link_to(contract_classification.name, edit_admin_contract_classification_path)
    end
    links
  end
  
  permit_params do
    permitted = [:name]
    permitted
  end

end
