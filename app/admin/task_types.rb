ActiveAdmin.register TaskType do
  menu priority: 9
  actions :all, except: [:show]

  permit_params do
    permitted = [:name]
    permitted
  end

  index do
    div id: '__privileges', 'data-privilege': "#{current_user.admin_privilege}"
    selectable_column if current_user.admin_delete?
    column :id
    column :name
    actions defaults: false do |task_type|
      item "Edit", edit_admin_task_type_path(task_type), title: 'Edit', class: "member_link edit_link" if current_user.admin_write?
      item "Delete", admin_task_type_path(task_type), title: 'Delete', class: "member_link delete_link", 'data-confirm': 'Are you sure you want to delete this?', method: 'delete' if current_user.admin_delete?
    end
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

  batch_action :destroy, if: proc {current_user.admin_delete?}, confirm: "Are you sure you want to delete these Task Types?" do |ids|
    deleted = TaskType.where(id: ids).destroy_all
    redirect_to collection_path, notice: "Successfully deleted #{deleted.count} Task Types"
  end

  filter :name
  filter :created_at
  filter :updated_at
  remove_filter :tasks

end
