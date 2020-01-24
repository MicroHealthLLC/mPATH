ActiveAdmin.register User do

  actions :index, :show, :edit, :update
  permit_params do
    permitted = [:email, :encrypted_password, project_ids: []]
  end
  
  form do |f|
    f.inputs 'Assign Projects' do
      f.input :email, input_html: { disabled: true } 
      f.input :projects, :label => 'Projects', :as => :select
    end
    f.actions
  end
  
  index do
    id_column
    column :email
    column :last_sign_in_at
    column :projects
    actions
  end

  filter :email
end
