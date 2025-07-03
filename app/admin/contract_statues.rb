ActiveAdmin.register ContractStatus do
  menu parent: "Contracts", priority: 1
  actions :all, except: [:show]
  
  breadcrumb do
    links = [link_to('Admin', admin_root_path), link_to('Contract Statuses', admin_contract_statuses_path)]
    if %(show edit).include?(params['action'])
      links << link_to(contract_status.name, edit_admin_contract_status_path)
    end
    div id: '__privileges', 'data-privilege': "#{current_user.admin_privilege}"
    links
  end

  index do
    div id: '__privileges', 'data-privilege': "#{current_user.admin_privilege}"
    column :name
    actions defaults: false do |cc|
      item "Edit", edit_admin_contract_status_path(cc), title: 'Edit', class: "member_link edit_link" if current_user.admin_write?
      item "Delete", admin_contract_status_path(cc), title: 'Delete', class: "member_link delete_link", 'data-confirm': 'Are you sure you want to delete this?', method: 'delete' if current_user.admin_delete?
    end
  end

  batch_action :destroy, if: proc {current_user.admin_delete?}, confirm: "Are you sure you want to delete these #{ContractStatus.name.titleize}" do |ids|
    deleted = ContractStatus.where(id: ids).destroy_all
    redirect_to collection_path, notice: "Successfully deleted #{deleted.count} #{ContractStatus.name.titleize}"
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
