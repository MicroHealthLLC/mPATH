ActiveAdmin.register SubcontractNumber do
  menu parent: "Contracts", priority: 1
  actions :all, except: [:show]

  breadcrumb do
    links = [link_to('Admin', admin_root_path), link_to('Sub Contract Numbers', admin_subcontract_numbers_path)]
    if %(show edit).include?(params['action'])
      links << link_to(subcontract_number.name, edit_admin_subcontract_number_path)
    end
    links
  end

  permit_params do
    permitted = [:name]
    permitted
  end

  preserve_default_filters!
  filter :contracts, collection: -> {
    Contract.pluck(:nickname, :id)
  }
end