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
    div id: '__privileges', 'data-privilege': "#{current_user.admin_privilege}"
    selectable_column if current_user.admin_write?
    column :id
    column :name
    column :code
    column "State", :status
    actions defaults: false do |facility_group|
      item "Edit", edit_admin_facility_group_path(facility_group), title: 'Edit', class: "member_link edit_link" if current_user.admin_write?
      item "Delete", admin_facility_group_path(facility_group), title: 'Delete', class: "member_link delete_link", 'data-confirm': 'Are you sure you want to delete this?', method: 'delete' if current_user.admin_delete?
    end
  end

  batch_action :assign_state, form: {
    "State": FacilityGroup.statuses&.to_a
  } do |ids, inputs|
    FacilityGroup.where(id: ids).update_all(status: inputs['State'].to_i)
    redirect_to collection_path, notice: 'State is updated'
  end

  batch_action :destroy, if: proc {current_user.admin_delete?}, confirm: "Are you sure you want to delete these Facility Groups?" do |ids|
    deleted = FacilityGroup.where(id: ids).destroy_all
    redirect_to collection_path, notice: "Successfully deleted #{deleted.count} Facility Groups"
  end

  controller do
    before_action :check_readability, only: [:index, :show]
    before_action :check_writeability, only: [:new, :edit, :update, :create]

    def check_readability
      redirect_to '/not_found' and return unless current_user.admin_read?
    end

    def check_writeability
      redirect_to '/not_found' and return unless current_user.admin_write?
    end

    def destroy
      redirect_to '/not_found' and return unless current_user.admin_delete?
      super
    end

    def index
      super do |format|
        format.json {send_data collection.to_json, type: :json, disposition: "attachment"}
      end
    end

  end

  filter :name
  filter :code
  filter :status, label: "State", as: :select, collection: FacilityGroup.statuses
end
