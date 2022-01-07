ActiveAdmin.register ContractCurrentPop do
  menu parent: "Contracts", priority: 1, label: "Contract Current PoPs"
  actions :all, except: [:show]

  index title: "Contract Current PoPs"

  permit_params do
    permitted = [:name]
    permitted
  end

  controller do
    def edit
      @page_title = "Edit Contract Current PoP"
    end
  end
end