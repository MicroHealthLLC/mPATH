ActiveAdmin.register Project do
  menu priority: 4

  permit_params do
    permitted = [:name, :description, :status, :project_type_id, user_ids: []]
    permitted
  end

  # action_item :regions, only: :show do
  #   link_to 'Regions', admin_project_regions_path(project)
  # end

  index do
    selectable_column
    id_column
    column :name
    column :description
    column :status
    actions
  end

  show do
    attributes_table do
      row :name
      row :description
      row :status
      row :regions
      row :users
    end
    active_admin_comments
  end

  form do |f|
    f.inputs 'Project Details' do
      f.input :name
      f.input :description
      f.input :status
      f.input :users, :label => 'Project Users', :as => :select, :collection => User.all.map{|u| [u.email, u.id]}
    end
    f.actions
  end

  filter :name
  filter :status

end
