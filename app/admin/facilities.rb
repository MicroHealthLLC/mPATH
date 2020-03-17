ActiveAdmin.register Facility do
  menu priority: 8
  actions :all, except: [:show]

  permit_params do
    permitted = [
      :facility_name,
      :address,
      :point_of_contact,
      :phone_number,
      :email,
      :notes,
      :facility_group_id,
      :creator_id,
      :status,
      :lat,
      :lng,
      project_ids: [],
      comments_attributes: [
        :namespace,
        :author_id,
        :author_type,
        :body
      ]
    ]
  end

  index do
    selectable_column
    id_column
    column :facility_name
    column :address
    column :point_of_contact
    column :email
    column :phone_number
    column :facility_group
    column :projects
    actions
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys

    tabs do
      tab 'Basic' do
        f.inputs 'Basic Details' do
          f.input :facility_name
          f.input :facility_group
          f.input :address
          f.input :lat
          f.input :lng
          div id: 'gmaps-tab'
          f.input :point_of_contact
          f.input :phone_number
          f.input :email
          f.input :notes
        end
      end

      tab 'Advanced' do
        f.inputs 'Assign Projects' do
          f.input :projects, label: 'Projects', as: :select, collection: Project.all.map{|p| [p.name, p.id]}
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

  controller do

    def create
      params[:facility][:creator_id] = current_user.id
      super
    end

    def update(options={}, &block)
      params[:facility][:comments_attributes]['0']['namespace'] = 'admin'
      params[:facility][:comments_attributes]['0']['author_id'] = current_user.id
      params[:facility][:comments_attributes]['0']['author_type'] = 'User'
      super do |success, failure|
        block.call(success, failure) if block
        failure.html { render :edit }
      end
    end
  end
end

