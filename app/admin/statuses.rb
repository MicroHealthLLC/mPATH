ActiveAdmin.register Status do
  menu priority: 7

  permit_params do
    permitted = [:name]
    permitted
  end

end

