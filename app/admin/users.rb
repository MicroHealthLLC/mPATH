ActiveAdmin.register User do
  menu priority: 2
  actions :all, except: [:show]

  permit_params do
    permitted = [
      :email,
      :first_name,
      :last_name,
      :title,
      :phone_number,
      :address,
      :role,
      :password,
      :password_confirmation,
      project_ids: []
    ]
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys

    tabs do
      tab 'Basic' do
        f.inputs 'Basic Details' do
          f.input :title
          f.input :first_name
          f.input :last_name
          f.input :email, input_html: { disabled: user.id? }
          if user.id.nil?
            f.input :password, input_html: { disabled: user.id? }
            f.input :password_confirmation, input_html: { disabled: user.id? }
          end
          f.input :role
          f.input :phone_number
          f.input :address
        end
      end

      tab 'Projects' do
        f.inputs 'Projects Details' do
          f.input :projects, label: 'Projects', as: :select
        end
      end
    end

    actions
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
