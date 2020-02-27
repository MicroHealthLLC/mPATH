ActiveAdmin.register User do
  menu priority: 2

  permit_params do
    permitted = [:email, :first_name, :last_name, :title, :phone_number, :address, :role, :password, :password_confirmation, project_ids: []]
  end

  form do |f|
    f.inputs 'Details' do
      f.input :title
      f.input :first_name
      f.input :last_name
      f.input :email, input_html: { disabled: user.id? }
      f.input :password, input_html: { disabled: user.id? }
      f.input :password_confirmation, input_html: { disabled: user.id? }
      f.input :role
      f.input :phone_number
      f.input :address
      f.input :projects, label: 'Projects', as: :select
    end

    f.actions
  end

  show do
    attributes_table do
      row :title
      row :first_name
      row :last_name
      row :email
      row :role
      row :phone_number
      row :address
      row :projects
    end
    active_admin_comments
  end

  index do
    selectable_column
    id_column
    column :title
    column :first_name
    column :last_name
    column :email
    column :role
    column :phone_number
    column :address
    column :projects
    actions
  end

  filter :email
  filter :title
  filter :first_name
  filter :last_name
  filter :phone_number
  filter :address

end
