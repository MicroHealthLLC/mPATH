ActiveAdmin.register ContractCurrentPop do
  menu parent: "Contracts", priority: 1, label: "Contract Current PoPs"
  actions :all, except: [:show]

  breadcrumb do
    links = [link_to('Admin', admin_root_path), link_to('Contract Current Pop', admin_contract_current_pops_path)]
    if %(show edit).include?(params['action'])
      links << link_to(contract_current_pop.name, edit_admin_contract_current_pop_path)
    end
    links
  end
  index title: "Contract Current PoPs"

  permit_params do
    permitted = [:name]
    permitted
  end


end