ActiveAdmin.register TaskType do
  menu priority: 6

  permit_params do
    permitted = [:name]
    permitted
  end

end
