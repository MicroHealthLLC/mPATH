ActiveAdmin.register State do
  menu false
  actions :all, except: [:edit, :new, :create, :update, :edit]

  permit_params do
    permitted = [:name, :facility_group_id]
    permitted
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs 'Details' do
      f.input :name
      f.input :code, input_html: {disabled: true}
      f.input :facility_group
    end
    f.actions
  end

  controller do
    def index
      super do |format|
        format.json {send_data collection.to_json, type: :json, disposition: "attachment"}
      end
    end
  end

  filter :name
  filter :code
  filter :facility_group

end
