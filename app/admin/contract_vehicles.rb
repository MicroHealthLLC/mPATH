ActiveAdmin.register ContractVehicle do
  menu parent: "Contracts", priority: 1
  actions :all, except: [:show]

  breadcrumb do
    links = [link_to('Admin', admin_root_path), link_to('Contract Vehicles', admin_contract_vehicles_path)]
    if %(show edit).include?(params['action'])
      links << link_to(contract_vehicle.name, edit_admin_contract_vehicle_path)
    end
    div id: '__privileges', 'data-privilege': "#{current_user.admin_privilege}"

    links
  end
  batch_action :destroy, if: proc {current_user.admin_delete?}, confirm: "Are you sure you want to delete these #{ContractVehicle.name.titleize}" do |ids|
    deleted = ContractVehicle.where(id: ids).destroy_all
    redirect_to collection_path, notice: "Successfully deleted #{deleted.count} #{ContractVehicle.name.titleize}"
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
