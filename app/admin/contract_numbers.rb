ActiveAdmin.register ContractNumber do
  menu parent: "Contracts", priority: 1
  actions :all, except: [:show]

  permit_params do
    permitted = [:name]
    permitted
  end
end