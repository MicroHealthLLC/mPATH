ActiveAdmin.register ContractPrime do
  menu parent: "Contracts", priority: 1
  actions :all, except: [:show]

  breadcrumb do
    links = [link_to('Admin', admin_root_path), link_to('Contract Primes', admin_contract_primes_path)]
    if %(show edit).include?(params['action'])
      links << link_to(contract_prime.name, edit_admin_contract_prime_path)
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