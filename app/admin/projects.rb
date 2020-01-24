ActiveAdmin.register Project do

  permit_params do
    permitted = [:name, :description, :status, :project_type, user_ids: []]
    permitted
  end
  
  form do |f|
    f.inputs 'Details' do
      f.input :name
      f.input :description
      f.input :status
      f.input :project_type
      f.input :users, :label => 'Project Users', :as => :select, :collection => User.all.map{|u| [u.email, u.id]}
    end
    f.actions
  end

  filter :name
  filter :status
  filter :project_type

end
