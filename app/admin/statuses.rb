ActiveAdmin.register Status do
  menu priority: 7
  actions :all, except: [:show]

  permit_params do
    permitted = [:name]
    permitted
  end

end

