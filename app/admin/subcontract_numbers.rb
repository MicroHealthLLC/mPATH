ActiveAdmin.register SubcontractNumber do
  menu parent: "Contracts", priority: 1
  actions :all, except: [:show]

  breadcrumb do
    links = [link_to('Admin', admin_root_path), link_to('Subcontract Numbers', admin_subcontract_numbers_path)]
    if %(show edit).include?(params['action'])
      links << link_to(subcontract_number.name, edit_admin_subcontract_number_path)
    end
    div id: '__privileges', 'data-privilege': "#{current_user.admin_privilege}"

    links
  end
  batch_action :destroy, if: proc {current_user.admin_delete?}, confirm: "Are you sure you want to delete these #{SubcontractNumber.name.titleize}" do |ids|
    deleted = SubcontractNumber.where(id: ids).destroy_all
    redirect_to collection_path, notice: "Successfully deleted #{deleted.count} #{SubcontractNumber.name.titleize}"
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