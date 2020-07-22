ActiveAdmin.register User do
  menu priority: 2
  actions :all, except: [:show]

  breadcrumb do
    links = [link_to('Admin', admin_root_path), link_to('Users', admin_users_path)]
    if %(show edit).include?(params['action'])
      links << link_to(user.email, edit_admin_user_path)
    end
    links
  end

  permit_params do
    permitted = [
      :email,
      :first_name,
      :last_name,
      :title,
      :phone_number,
      :address,
      :lat,
      :lng,
      :password,
      :password_confirmation,
      :status,
      :privileges,
      :country_code,
      project_ids: [],
      privilege_attributes: [
        :id,
        :overview,
        :tasks,
        :issues,
        :notes,
        :admin
      ]
    ]
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys

    tabs do
      tab 'Basic' do
        f.inputs 'Basic Details' do
          f.input :title
          f.input :first_name
          f.input :last_name
          f.input :email, input_html: { disabled: user.id?, :'data-id' => user.id }
          f.input :password, input_html: { disabled: user.id? }
          f.input :password_confirmation, input_html: { disabled: user.id? }
          f.input :phone_number
          f.input :country_code
          div id: 'user_phone_number-tab'
          f.input :address
          f.input :lat
          f.input :lng
          div id: 'gmap-key', "data-key": Setting['GOOGLE_MAP_KEY']
          div id: 'user-gmaps-tab'
          f.input :status, include_blank: false, include_hidden: false, label: "State"
          div id: 'user-role_privilege-tab'
          f.inputs for: [:privilege, f.object.privilege || Privilege.new] do |p|
              p.input :overview
              p.input :tasks
              p.input :issues
              p.input :notes
              p.input :admin
          end
        end
        div id: 'user-password__tab'
      end

      tab 'Projects' do
        f.inputs 'Projects Details' do
          f.input :projects, label: 'Projects', as: :select, include_blank: false
        end
      end
    end

    actions
  end

  index do
    div id: '__privileges', 'data-privilege': "#{current_user.admin_privilege}"
    selectable_column if current_user.admin_write?
    column :title
    column :first_name
    column :last_name
    column :email
    column "State", :status
    column :phone_number
    column :address
    column(:projects) {|user| user.projects.active}
    actions defaults: false do |user|
      item "Edit", edit_admin_user_path(user), title: 'Edit', class: "member_link edit_link" if current_user.admin_write? && current_user.id != user.id
      item "Delete", admin_user_path(user), title: 'Delete', class: "member_link delete_link", 'data-confirm': 'Are you sure you want to delete this?', method: 'delete' if current_user.admin_delete? && current_user.id != user.id
    end
  end

  batch_action :assign_state, form: {
    "State": User.statuses&.to_a
  } do |ids, inputs|
    User.where(id: ids).update_all(status: inputs['State'].to_i)
    redirect_to collection_path, notice: 'State is updated'
  end

  batch_action :"Assign/Unassign Project", form: -> {{
    assign: :checkbox,
    "Project": Project.pluck(:name, :id)
  }} do |ids, inputs|
    notice = "Project is assigned"
    project = Project.find_by_id(inputs["Project"])
    if inputs['assign'] === 'assign'
      User.where(id: ids).each do |user|
        user.projects << project unless user.projects.pluck(:id).include?(project.id)
      end
      notice = "Project is assigned"
    elsif inputs['assign'] === 'unassign'
      ProjectUser.where(project_id: project.id, user_id: ids).destroy_all
      notice = "Project is unassigned"
    end
    redirect_to collection_path, notice: "#{notice}"
  end

  batch_action :destroy, if: proc {current_user.admin_delete?}, confirm: "Are you sure you want to delete these Users?" do |ids|
    deleted = User.where(id: ids).where.not(id: current_user.id).destroy_all
    redirect_to collection_path, notice: "Successfully deleted #{deleted.count} Users"
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

  filter :email
  filter :projects, as: :select, collection: -> {Project.active}
  filter :title
  filter :first_name
  filter :last_name
  filter :phone_number
  filter :address
  filter :status, as: :select, collection: User.statuses, label: "State"
  remove_filter :lat
  remove_filter :lng
end
