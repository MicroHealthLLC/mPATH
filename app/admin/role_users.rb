return # We will not show role management in admin panel

ActiveAdmin.register RoleUser do
  menu parent: "Roles", priority: 1
  actions :all, except: [:show]

  permit_params do
    permitted = [:user_id, :role_id, :facility_project_id, :contract_id, :project_id]
    permitted
  end

  breadcrumb do
    links = [link_to('Admin', admin_root_path), link_to('Roles', admin_role_users_path)]
    if %(show edit).include?(params['action'])
      links << link_to(role.name, edit_admin_role_user_path(role_user))
    end
    links
  end

  index do
    selectable_column if current_user.admin_delete?
    column :id
    column :user
    column :project
    column :contract
    column :role
    column :facility_project do |role_user|
       role_user.facility_project ? link_to("#{role_user.facility_project.facility.facility_name}", "#{admin_facility_path(role_user.facility_project.facility)}") : nil
    end
    actions defaults: false do |role|
      item "Edit", edit_admin_role_user_path(role), title: 'Edit', class: "member_link edit_link"
      item "Delete", admin_role_user_path(role), title: 'Delete', class: "member_link delete_link", 'data-confirm': 'Are you sure you want to delete this?', method: 'delete' if current_user.admin_delete?
    end
  end

  batch_action :destroy, if: proc {current_user.admin_delete?}, confirm: "Are you sure you want to delete these Roles?" do |ids|
    deleted = Role.where(id: ids).destroy_all
    redirect_to collection_path, notice: "Successfully deleted #{deleted.count} Role"
  end

  controller do
    before_action :check_readability, only: [:index, :show]
    # before_action :check_order, only: [:index]
    before_action :check_writeability, only: [:new, :edit, :update, :create]
    
    def scoped_collection
      super.includes [{facility_project: :facility }, :contract, :project, :user]
    end

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

    # def check_order
    #   order = Role.sort_order?
    #   redirect_to admin_role_userss_path(order: order) and return unless params[:order] == order
    # end

    def index
      super do |format|
        format.json {send_data collection.to_json, type: :json, disposition: "attachment"}
      end
    end
  end

  filter :name
  filter :created_at
  filter :updated_at
  filter :id, as: :select, collection: -> {[current_user.admin_privilege]}, input_html: {id: '__privileges_id'}, include_blank: false
end
