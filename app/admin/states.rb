ActiveAdmin.register State do
  menu false
  actions :all, except: [:edit, :new]

  permit_params do
    permitted = [:name, :facility_group_id]
    permitted
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys

    f.inputs 'Details' do
      f.input :name
      f.input :code, input_html: { disabled: true }
      f.input :facility_group
    end
    f.actions
  end

  filter :name
  filter :code
  filter :facility_group

end
