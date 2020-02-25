ActiveAdmin.register State do
  menu false
  actions :index, :show

  permit_params do
    permitted = [:name, :region_id]
    permitted
  end

  form do |f|
    f.inputs 'Details' do
      f.input :name
      f.input :code, input_html: { disabled: true } 
      f.input :region
    end
    f.actions
  end

  filter :name
  filter :code
  filter :region
  
end
