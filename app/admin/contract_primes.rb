# ActiveAdmin.register ContractPrime do
#   menu parent: "Contracts", priority: 1
#   actions :all, except: [:show]

#   breadcrumb do
#     links = [link_to('Admin', admin_root_path), link_to('Contract Primes', admin_contract_primes_path)]
#     if %(show edit).include?(params['action'])
#       links << link_to(contract_prime.name, edit_admin_contract_prime_path)
#     end
#     div id: '__privileges', 'data-privilege': "#{current_user.admin_privilege}"
#     links
#   end
  
#   index do
#     div id: '__privileges', 'data-privilege': "#{current_user.admin_privilege}"
#     column :name
#     actions defaults: false do |cc|
#       item "Edit", edit_admin_contract_prime_path(cc), title: 'Edit', class: "member_link edit_link" if current_user.admin_write?
#       item "Delete", admin_contract_prime_path(cc), title: 'Delete', class: "member_link delete_link", 'data-confirm': 'Are you sure you want to delete this?', method: 'delete' if current_user.admin_delete?
#     end
#   end

#   batch_action :destroy, if: proc {current_user.admin_delete?}, confirm: "Are you sure you want to delete these #{ContractPrime.name.titleize}" do |ids|
#     deleted = ContractPrime.where(id: ids).destroy_all
#     redirect_to collection_path, notice: "Successfully deleted #{deleted.count} #{ContractPrime.name.titleize}"
#   end
#   permit_params do
#     permitted = [:name]
#     permitted
#   end
#   preserve_default_filters!
#   filter :contracts, collection: -> {
#     Contract.pluck(:nickname, :id)
#   }
# end