ActiveAdmin.register User do
  menu priority: 2
  actions :all, except: [:show]

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
          f.input :email, input_html: { disabled: user.id? }
          if user.id.nil?
            f.input :password, input_html: { disabled: user.id? }
            f.input :password_confirmation, input_html: { disabled: user.id? }
          end
          f.input :role, include_blank: false, include_hidden: false
          f.input :phone_number
          f.input :address
          f.input :lat
          f.input :lng
          div id: 'gmap-key', "data-key": Setting['GOOGLE_MAP_KEY']
          div id: 'user-gmaps-tab'
          f.input :status, include_blank: false, include_hidden: false, label: "State"
        end

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

  batch_action :assign_projects, confirm: 'Are you sure?', form: -> {{
    project: Project.pluck(:name, :id)
  }} do |ids, inputs|
    project = Project.find_by_id(inputs[:project])
    User.where(id: ids).each do |user|
      user.projects << project unless user.projects.pluck(:id).include?(project.id)
    end
    redirect_to collection_path, notice: "Assigned projects updated"
  end

  controller do
    def index
      super do |format|
        format.json { send_data collection.to_json, type: :json, disposition: "attachment" }
      end
    end

    def create
      if params["user"]["privileges_collection"].present?
        privileges = params["user"]["privileges_collection"].compact.split("").flatten.join(", ")
        params["user"].merge!({"privileges": privileges})
      end
      super
    end

    def update
      if params["user"]["privileges_collection"].present?
        privileges = params["user"]["privileges_collection"].compact.split("").flatten.join(", ")
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
