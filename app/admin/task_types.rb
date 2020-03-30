ActiveAdmin.register TaskType do
  menu priority: 9
  actions :all, except: [:show]

  permit_params do
    permitted = [:name]
    permitted
  end

end
