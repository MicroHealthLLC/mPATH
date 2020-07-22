ActiveAdmin.register Project do
  menu priority: 3
  actions :all, except: [:show]

  permit_params do
    permitted = [
      :name,
      :description,
      :project_type_id,
      :status,
      user_ids: [],
      comments_attributes: [
        :namespace,
        :author_id,
        :author_type,
        :body
      ]
    ]
    permitted
  end

  index do
    div id: '__privileges', 'data-privilege': "#{current_user.admin_privilege}"
    selectable_column if current_user.admin_write?
    column :name
    column :description
    column :project_type, nil, sortable: 'project_types.name' do |project|
      raw "<a href='#{edit_admin_project_type_path(project.project_type)}'>#{project.project_type.name}</a>" if project.project_type.present?
    end
    column "State", :status
    actions defaults: false do |project|
      item "Edit", edit_admin_project_path(project), title: 'Edit', class: "member_link edit_link" if current_user.admin_write?
      item "Delete", admin_project_path(project), title: 'Delete', class: "member_link delete_link", 'data-confirm': 'Are you sure you want to delete this?', method: 'delete' if current_user.admin_delete?
    end
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys

    tabs do
      tab 'Basic' do
        f.inputs 'Basic Details' do
          f.input :name
          f.input :project_type
          f.input :status, include_blank: false, include_hidden: false, label: "State"
          f.input :description
        end
      end

      tab 'Advanced' do
        f.inputs 'Project Details' do
          f.input :users, label: 'Project Users', as: :select, collection: User.client.map{|u| [u.email, u.id]}
        end
      end

      tab 'Comments' do
        panel "Comments" do
          div class: 'comments custom_made' do
            resource.comments.each do |comment|
              div for: comment do
                div class: 'active_admin_comment_meta' do
                  h4 class: 'active_admin_comment_author' do
                    comment.author ? auto_link(comment.author) : I18n.t('active_admin.comments.author_missing')
                  end
                  div pretty_format comment.created_at
                  if authorized?(ActiveAdmin::Auth::DESTROY, comment)
                    text_node link_to I18n.t('active_admin.comments.delete'), admin_comment_url(comment.id), method: :delete, data: {confirm: I18n.t('active_admin.comments.delete_confirmation')}
                  end
                end
                div class: 'active_admin_comment_body' do
                  simple_format comment.body
                end
              end
            end

            f.semantic_fields_for :comments, ActiveAdmin::Comment.new do |c|
              c.inputs :class => "" do
                c.input :body, label: "Comment", required: false, input_html: {rows: 8}
              end
            end
          end
        end
      end
    end

    f.actions

  end

  filter :name
  filter :project_type
  filter :status, as: :select, collection: Project.statuses, label: "State"

  batch_action :assign_state, form: {
    "State": Project.statuses&.to_a
  } do |ids, inputs|
    Project.where(id: ids).update_all(status: inputs['State'].to_i)
    redirect_to collection_path, notice: 'State is updated'
  end

  batch_action :destroy, if: proc {current_user.admin_delete?}, confirm: "Are you sure you want to delete these Projects?" do |ids|
    deleted = Project.where(id: ids).destroy_all
    redirect_to collection_path, notice: "Successfully deleted #{deleted.count} Projects"
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

    def update(options={}, &block)
      params[:project][:comments_attributes]['0']['namespace'] = 'admin'
      params[:project][:comments_attributes]['0']['author_id'] = current_user.id
      params[:project][:comments_attributes]['0']['author_type'] = 'User'
      super do |success, failure|
        block.call(success, failure) if block
        failure.html {render :edit}
      end
    end

    def index
      super do |format|
        format.json {send_data collection.to_json, type: :json, disposition: "attachment"}
      end
    end

    def scoped_collection
      super.includes(:project_type)
    end
  end

end
