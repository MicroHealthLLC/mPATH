ActiveAdmin.register Region do


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
      f.input :states
    end
    f.actions
  end

  index do
    id_column
    column :name
    column :code
    column :color
    column :status
    column :states
    actions
  end

  filter :name
  filter :code
  filter :status
  filter :color
  
end
