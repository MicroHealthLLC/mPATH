ActiveAdmin.register Project do
  menu priority: 4

  permit_params do
    permitted = [:name, :description, :status_id, :project_type_id, user_ids: []]
    permitted
  end

  index do
    selectable_column
    id_column
    column :name
    column :description
    column :status
    column :project_type
    actions
  end

  show do
    attributes_table do
      row :name
      row :description
      row :status
      row :project_type
      row :users do
        project.users.pluck(:email).join(', ')
      end
    end
    active_admin_comments
  end

  form do |f|
    f.inputs 'Project Details' do
      f.input :name
      f.input :description
      f.input :status
      f.input :project_type
      f.input :users, label: 'Project Users', as: :select, collection: User.subscriber.map{|u| [u.email, u.id]}
    end
    f.actions
  end

  filter :name
  filter :status
  filter :project_type
end
