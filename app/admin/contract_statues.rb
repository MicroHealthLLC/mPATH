ActiveAdmin.register ContractStatus do
  menu parent: "Contracts", priority: 1
  actions :all, except: [:show]

  permit_params do
    permitted = [:name]
    permitted
  end
  preserve_default_filters!
  filter :contracts, collection: -> {
    Contract.pluck(:nickname, :id)
  }
end
