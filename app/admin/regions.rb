ActiveAdmin.register Region do

  menu priority: 5

  permit_params do
    permitted = [:name, :code, :status, :color, state_ids: []]
    permitted
  end

  form do |f|
    f.inputs 'Details' do
      f.input :name
      f.input :code
      f.input :color
      f.input :status
      f.input :states, as: :select, collection: State.where(nil)
    end
    f.actions
  end

  index do
    selectable_column
    id_column
    column :name
    column :code
    column :color
    column :status
    column :states
    actions
  end

  show do
    attributes_table do
      row :name
      row :code
      row :color
      row :status
      row :project
      row :states
    end
    active_admin_comments
  end

  filter :name
  filter :code
  filter :status
  filter :color
  
end
