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
          div id: 'user-gmaps-tab'
          f.input :status, include_blank: false, include_hidden: false
        end
      end

      tab 'Projects' do
        f.inputs 'Projects Details' do
          f.input :projects, label: 'Projects', as: :select
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
    column :status
    column :phone_number
    column :address
    column(:projects) { |user| user.projects.active }
    actions
  end

  batch_action :assign_status, form: {
    status: User.statuses&.to_a
  } do |ids, inputs|
    User.where(id: ids).update_all(status: inputs['status'].to_i)
    redirect_to collection_path, notice: 'Status is updated'
  end

  batch_action :assign_projects, confirm: 'Are you sure?', form: {
    project: (Project.pluck(:name, :id))
  } do |ids, inputs|
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
  end

  filter :email
  filter :title
  filter :projects, as: :select, collection: Project.active
  filter :role, as: :select, collection: User.roles
  filter :first_name
  filter :last_name
  filter :phone_number
  filter :address
  filter :status, as: :select, collection: User.statuses
  remove_filter :lat
  remove_filter :lng
end
