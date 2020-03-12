ActiveAdmin.register FacilityGroup do
  menu priority: 3
  actions :all, except: [:show]

  permit_params do
    permitted = [
      :name,
      :code,
      :status,
      :color
    ]
    permitted
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys

    inputs 'Details' do
      f.input :name
      f.input :code
      f.input :color
      f.input :status
    end
    actions
  end

  index do
    selectable_column
    id_column
    column :name
    column :code
    column :color
    column :status
    actions
  end

  filter :name
  filter :code
  filter :status
  filter :color
end
