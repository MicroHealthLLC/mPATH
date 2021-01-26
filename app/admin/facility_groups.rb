ActiveAdmin.register FacilityGroup do
  menu parent: "Facilities", label: "Project Groups"
  actions :all, except: [:show]

  permit_params do
    permitted = [
      :name,
      :code,
      :status
    ]
    permitted
  end

  breadcrumb do
    links = [link_to('Admin', admin_root_path), link_to('Project Groups', admin_facility_groups_path)]
    if %(show edit).include?(params['action'])
      links << link_to(facility_group.name, edit_admin_facility_group_path)
    end
    links
  end

  # form_title = @facility_group.new_record? ? "New Project Group" : "Edit Project Group"

  form title: proc{|g| g.new_record? ? "New Project Group" : "Edit Project Group" } do |f|
    f.semantic_errors *f.object.errors.keys

    inputs 'Details' do
      f.input :name
      f.input :code
      f.input :status, include_blank: false, include_hidden: false, label: "State"
    end

    f.actions do
      f.action :submit, :as => :button, :label => "Create Project Group"
      f.action :cancel, :label => "Cancel", wrapper_html: {class: "cancel"}
    end
  end
  config.clear_action_items!

  action_item :only => :index do
    link_to "New Project Group" , new_admin_facility_group_path
  end
  index title: 'Project Group' do
    div id: '__privileges', 'data-privilege': "#{current_user.admin_privilege}"
    selectable_column if current_user.admin_write? || current_user.admin_delete?
    column :id
    column :name
    column :code
    tag_column "State", :status
    actions defaults: false do |facility_group|
      item "Edit", edit_admin_facility_group_path(facility_group), title: 'Edit', class: "member_link edit_link" if current_user.admin_write?
      item "Delete", admin_facility_group_path(facility_group), title: 'Delete', class: "member_link delete_link", 'data-confirm': 'Are you sure you want to delete this?', method: 'delete' if current_user.admin_delete?
    end
  end

  batch_action :assign_state, if: proc {current_user.admin_write?}, form: {
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
    before_action :check_order, only: [:index]
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
    rescue ActiveRecord::StatementInvalid
      flash[:error] = "Not able to delete this! Violates foreign key constraint."
      redirect_back fallback_location: root_path
    end

    def check_order
      order = FacilityGroup.sort_order?
      redirect_to admin_facility_groups_path(order: order) and return unless params[:order] == order
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
  filter :id, as: :select, collection: -> {[current_user.admin_privilege]}, input_html: {id: '__privileges_id'}, include_blank: false
end
