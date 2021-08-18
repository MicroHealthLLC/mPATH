ActiveAdmin.register TaskType do
  menu priority: 7, label: "Process Areas"
  actions :all, except: [:show]

  permit_params do
    permitted = [:name]
    permitted
  end

  breadcrumb do
    links = [link_to('Admin', admin_root_path), link_to('Process Areas', admin_task_types_path)]
    if %(show edit).include?(params['action'])
      links << link_to(task_type.name, edit_admin_task_type_path)
    end
    links
  end

  index title: 'Process Areas' do
    div id: '__privileges', 'data-privilege': "#{current_user.admin_privilege}"
    selectable_column if current_user.admin_delete?
    column :id
    column :name
    actions defaults: false do |task_type|
      item "Edit", edit_admin_task_type_path(task_type), title: 'Edit', class: "member_link edit_link" if current_user.admin_write?
      item "Delete", admin_task_type_path(task_type), title: 'Delete', class: "member_link delete_link", 'data-confirm': 'Are you sure you want to delete this?', method: 'delete' if current_user.admin_delete?
    end
  end


  form(html: {autocomplete: :off}) do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs do
      f.input :name
    end
    actions
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
      order = TaskType.sort_order?
      redirect_to admin_task_types_path(order: order) and return unless params[:order] == order
    end

    def index
      super do |format|
        format.json {send_data collection.to_json, type: :json, disposition: "attachment"}
      end
    end
  end

  batch_action :destroy, if: proc {current_user.admin_delete?}, confirm: "Are you sure you want to delete these Process Areas?" do |ids|
    deleted = TaskType.where(id: ids).destroy_all
    redirect_to collection_path, notice: "Successfully deleted #{deleted.count} Process Areas"
  end

  filter :name
  filter :created_at
  filter :updated_at
  filter :id, as: :select, collection: -> {[current_user.admin_privilege]}, input_html: {id: '__privileges_id'}, include_blank: false
  remove_filter :tasks

end
