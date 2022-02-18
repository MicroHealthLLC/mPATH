ActiveAdmin.register ContractCurrentPop do
  menu parent: "Contracts", priority: 1, label: "Contract Current PoPs"
  actions :all, except: [:show]
  config.clear_action_items!

  action_item :new, only: [:index] do
    link_to "New Contract Current PoP", new_admin_contract_current_pop_path
  end

  breadcrumb do
    links = [link_to('Admin', admin_root_path), link_to('Contract Current PoPs', admin_contract_current_pops_path)]
    if %(show edit).include?(params['action'])
      links << link_to(contract_current_pop.name, edit_admin_contract_current_pop_path)
    end
    div id: '__privileges', 'data-privilege': "#{current_user.admin_privilege}"
    links
  end
  index title: "Contract Current PoPs"

  batch_action :destroy, if: proc {current_user.admin_delete?}, confirm: "Are you sure you want to delete these #{ContractCurrentPop.name.titleize}" do |ids|
    deleted = ContractCurrentPop.where(id: ids).destroy_all
    redirect_to collection_path, notice: "Successfully deleted #{deleted.count} #{ContractCurrentPop.name.titleize}"
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