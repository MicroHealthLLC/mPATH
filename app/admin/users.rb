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
      :role,
      :lat,
      :lng,
      :password,
      :password_confirmation,
      :status,
      :privileges,
      :country_code,
      project_ids: []
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
          f.input :role, include_blank: false, include_hidden: false
          f.input :phone_number
          f.input :country_code
          div id: 'user_phone_number-tab'
          f.input :address
          f.input :lat
          f.input :lng
          div id: 'gmap-key', "data-key": Setting['GOOGLE_MAP_KEY']
          div id: 'user-gmaps-tab'
          f.input :status, include_blank: false, include_hidden: false, label: "State"
        end

        div id: 'user-password__tab'

        # if user.subscriber?
          f.inputs 'Role Privileges', id: '__privileges' do
            f.input :privileges, input_html: { disabled: true }
            f.input :privileges_collection, label: 'Can Manages', as: :check_boxes, collection: User::PRIVILIGES, include_blank: false
          end
        # end
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
    selectable_column
    column :title
    column :first_name
    column :last_name
    column :email
    column :role
    column "State", :status
    column :phone_number
    column :address
    column(:projects) { |user| user.projects.active }
    actions
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

  controller do
    def index
      super do |format|
        format.json { send_data collection.to_json, type: :json, disposition: "attachment" }
      end
    end

    def create
      if params["user"]["privileges_collection"].present?
        privileges = params["user"]["privileges_collection"].compact.split(" ").flatten.join(", ")
        params["user"].merge!({"privileges": privileges})
      end
      super
    end

    def update
      if params["user"]["privileges_collection"].present?
        privileges = params["user"]["privileges_collection"].compact.split(" ").flatten.join(", ")
        params["user"].merge!({"privileges": privileges})
      end
      super
    end

    def edit
      resource.priviliges_collection = resource.privileges.split(",")
      super
    end
  end

  filter :email
  filter :projects, as: :select, collection: Project.active
  filter :role, as: :select, collection: User.roles
  filter :title
  filter :first_name
  filter :last_name
  filter :phone_number
  filter :address
  filter :status, as: :select, collection: User.statuses, label: "State"
  remove_filter :lat
  remove_filter :lng
end
