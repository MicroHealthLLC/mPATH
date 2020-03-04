ActiveAdmin.register ProjectType do
  menu priority: 5
  actions :all, except: [:show]

  permit_params do
    permitted = [:name]
    permitted
  end

end
