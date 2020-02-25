ActiveAdmin.register ProjectType do
  menu priority: 5

  permit_params do
    permitted = [:name, :description, :status, :project_type_id, user_ids: []]
    permitted
  end

end
