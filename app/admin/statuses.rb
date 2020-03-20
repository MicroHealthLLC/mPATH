ActiveAdmin.register Status do
  menu priority: 8
  actions :all, except: [:show]

  permit_params do
    permitted = [:name]
    permitted
  end

end

