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
    selectable_column
    column :name
    column :description
    column :project_type
    column "State", :status
    actions
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
          f.input :users, label: 'Project Users', as: :select, collection: User.subscriber.map{|u| [u.email, u.id]}
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
                  span pretty_format comment.created_at
                  if authorized?(ActiveAdmin::Auth::DESTROY, comment)
                    text_node link_to I18n.t('active_admin.comments.delete'), admin_comment_url(comment.id), method: :delete, data: { confirm: I18n.t('active_admin.comments.delete_confirmation') }
                  end
                end
                div class: 'active_admin_comment_body' do
                  simple_format comment.body
                end
              end
            end

            f.semantic_fields_for :comments, ActiveAdmin::Comment.new do |c|
              c.inputs :class => "" do
                c.input :body, label: "Comment", input_html: { rows: 8 }
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
  filter :status, label: 'State', as: :select, collection: Project.statuses

  batch_action :assign_state, form: {
    state: Project.statuses&.to_a
  } do |ids, inputs|
    Project.where(id: ids).update_all(status: inputs['status'].to_i)
    redirect_to collection_path, notice: 'State is updated'
  end

  controller do
    def update(options={}, &block)
      params[:project][:comments_attributes]['0']['namespace'] = 'admin'
      params[:project][:comments_attributes]['0']['author_id'] = current_user.id
      params[:project][:comments_attributes]['0']['author_type'] = 'User'
      super do |success, failure|
        block.call(success, failure) if block
        failure.html { render :edit }
      end
    end

    def index
      super do |format|
        format.json { send_data collection.to_json, type: :json, disposition: "attachment" }
      end
    end

  end
end
