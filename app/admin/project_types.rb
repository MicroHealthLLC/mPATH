ActiveAdmin.register ProjectType do
  menu priority: 4
  actions :all, except: [:show]

  permit_params do
    permitted = [:name]
    permitted
  end

end
