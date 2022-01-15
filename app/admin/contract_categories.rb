ActiveAdmin.register ContractCategory do
  menu parent: "Contracts", priority: 1
  actions :all, except: [:show]

  breadcrumb do
    links = [link_to('Admin', admin_root_path), link_to('Contract Categories', admin_contract_categories_path)]
    if %(show edit).include?(params['action'])
      links << link_to(contract_category.name, edit_admin_contract_category_path)
    end
    links
  end
  
  permit_params do
    permitted = [:name]
    permitted
  end

end
