ActiveAdmin.register ContractCategory do
  menu parent: "Contracts", priority: 1
  actions :all, except: [:show]

  breadcrumb do
    links = [link_to('Admin', admin_root_path), link_to('Contract Categories', admin_contract_categories_path)]
    if %(show edit).include?(params['action'])
      links << link_to(contract_category.name, edit_admin_contract_category_path)
    end
    div id: '__privileges', 'data-privilege': "#{current_user.admin_privilege}"
    links
  end

  batch_action :destroy, if: proc {current_user.admin_delete?}, confirm: "Are you sure you want to delete these Contract categories" do |ids|
    deleted = ContractCategory.where(id: ids).destroy_all
    redirect_to collection_path, notice: "Successfully deleted #{deleted.count} Contract categories"
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
