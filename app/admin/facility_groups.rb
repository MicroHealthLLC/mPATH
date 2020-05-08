ActiveAdmin.register FacilityGroup do
  menu priority: 5
  actions :all, except: [:show]

  permit_params do
    permitted = [
      :name,
      :code,
      :status
    ]
    permitted
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys

    inputs 'Details' do
      f.input :name
      f.input :code
      f.input :status, include_blank: false, include_hidden: false, label: "State"
    end
    actions
  end

  index do
    selectable_column
    column :name
    column :code
    column "State", :status
    actions
  end

  batch_action :assign_state, form: {
    state: FacilityGroup.statuses&.to_a
  } do |ids, inputs|
    FacilityGroup.where(id: ids).update_all(status: inputs['status'].to_i)
    redirect_to collection_path, notice: 'State is updated'
  end

  controller do
    def index
      super do |format|
        format.json { send_data collection.to_json, type: :json, disposition: "attachment" }
      end
    end
  end

  filter :name
  filter :code
  filter :status, label: 'State', as: :select, collection: FacilityGroup.statuses
end
