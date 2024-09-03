ActiveAdmin.register LessonStage do
  menu parent: "Lessons", priority: 3
  actions :all, except: [:show]

  permit_params do
    permitted = [:name]
    permitted
  end

  breadcrumb do
    links = [link_to('Admin', admin_root_path), link_to('Lesson Stages', admin_lesson_stages_path)]
    if %(show edit).include?(params['action'])
      links << link_to(lesson_stage.name, edit_admin_lesson_stage_path)
    end
    links
  end

  index do
    div id: '__privileges', 'data-privilege': "#{current_user.admin_privilege}"
    selectable_column if current_user.admin_delete?
    column :id
    column :name
    actions defaults: false do |lesson_stage|
      item "Edit", edit_admin_lesson_stage_path(lesson_stage), title: 'Edit', class: "member_link edit_link" if current_user.admin_write?
      item "Delete", admin_lesson_stage_path(lesson_stage), title: 'Delete', class: "member_link delete_link", 'data-confirm': 'Are you sure you want to delete this?', method: 'delete' if current_user.admin_delete?
    end
  end

  form do |f|
    f.semantic_errors *f.object.errors
    f.inputs do
      f.input :name
    end
    f.actions
  end

  batch_action :destroy, if: proc {current_user.admin_delete?}, confirm: "Are you sure you want to delete these Lesson Stages?" do |ids|
    deleted = LessonStage.where(id: ids).destroy_all
    redirect_to collection_path, notice: "Successfully deleted #{deleted.count} Lesson Stages"
  end

  controller do
    before_action :check_readability, only: [:index, :show]
    # before_action :check_order, only: [:index]
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
      order = LessonStage.sort_order?
      redirect_to admin_lesson_stages_path(order: order) and return unless params[:order] == order
    end

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