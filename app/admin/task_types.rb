ActiveAdmin.register TaskType do
  menu priority: 6
  actions :all, except: [:show]

  permit_params do
    permitted = [:name]
    permitted
  end

end
