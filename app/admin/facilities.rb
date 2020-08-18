ActiveAdmin.register Facility do
  menu priority: 6
  actions :all, except: [:show]

  breadcrumb do
    links = [link_to('Admin', admin_root_path), link_to('Facilities', admin_facilities_path)]
    if %(show edit).include?(params['action'])
      links << link_to(facility.facility_name, edit_admin_facility_path)
    end
    links
  end

  permit_params do
    permitted = [
      :facility_name,
      :address,
      :point_of_contact,
      :phone_number,
      :country_code,
      :email,
      :facility_group_id,
      :creator_id,
      :status,
      :lat,
      :lng,
      :status,
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
    div id: '__privileges', 'data-privilege': "#{current_user.admin_privilege}"
    selectable_column if current_user.admin_write? || current_user.admin_delete?
    column :facility_name
    column :address
    column :point_of_contact
    column :email
    column :phone_number
    column :facility_group, nil, sortable: 'facility_groups.name' do |facility|
      if current_user.admin_write?
        link_to "#{facility.facility_group.name}", "#{edit_admin_facility_group_path(facility.facility_group)}" if facility.facility_group.present?
      else
        "<span>#{facility.facility_group&.name}</span>".html_safe
      end
    end
    column "State", :status
    column :projects do |facility|
      if current_user.admin_write?
        facility.projects.active
      else
        "<span>#{facility.projects.active.pluck(:name).join(', ')}</span>".html_safe
      end
    end
    actions defaults: false do |facility|
      item "Edit", edit_admin_facility_path(facility), title: 'Edit', class: "member_link edit_link" if current_user.admin_write?
      item "Delete", admin_facility_path(facility), title: 'Delete', class: "member_link delete_link", 'data-confirm': 'Are you sure you want to delete this?', method: 'delete' if current_user.admin_delete?
    end
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
          div id: 'gmap-key', "data-key": Setting['GOOGLE_MAP_KEY']
          div id: 'gmaps-tab'
          f.input :point_of_contact
          f.input :phone_number
          f.input :country_code
          div id: 'f_phone_number-tab'
          f.input :email
          f.input :status, include_blank: false, include_hidden: false, label: "State"
        end
      end

      tab 'Advanced' do
        f.inputs 'Assign Projects' do
          f.input :projects, label: 'Projects', as: :select, collection: Project.all.map{|p| [p.name, p.id]}
        end
        div id: 'facility_projects-tab', "data-key": "#{resource.id}"
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
                c.input :body, label: "Comment", required: false, input_html: {rows: 8}
              end
            end
          end
        end
      end
    end

    f.actions

  end

  batch_action :"Assign/Unassign Facility Group", if: proc {current_user.admin_write?}, form: -> {{
    assign: :checkbox,
    "Facility Group": FacilityGroup.pluck(:name, :id)
  }} do |ids, inputs|
    notice = "Facility group is updated"
    if inputs['assign'] === 'assign'
      Facility.where(id: ids).update_all(facility_group_id: inputs["Facility Group"])
      notice = "Facility group is assigned"
    elsif inputs['assign'] === 'unassign'
      Facility.where(id: ids, facility_group_id: inputs["Facility Group"]).update_all(facility_group_id: nil)
      notice = "Facility group is unassigned"
    end
    redirect_to collection_path, notice: "#{notice}"
  end

  batch_action :assign_state, if: proc {current_user.admin_write?}, form: {
    state: Facility.statuses&.to_a
  } do |ids, inputs|
    Facility.where(id: ids).update_all(status: inputs['state'].to_i)
    redirect_to collection_path, notice: 'State is updated'
  end

  batch_action :"Assign/Unassign Project", if: proc {current_user.admin_write?}, form: -> {{
    assign: :checkbox,
    "Project": Project.pluck(:name, :id)
  }} do |ids, inputs|
    notice = "Project is assigned"
    project = Project.find_by_id(inputs["Project"])
    if inputs['assign'] === 'assign'
      Facility.where(id: ids).each do |facility|
        facility.projects << project unless facility.projects.pluck(:id).include?(project.id)
      end
      notice = "Project is assigned"
    elsif inputs['assign'] === 'unassign'
      FacilityProject.where(project_id: project.id, facility_id: ids).destroy_all
      notice = "Project is unassigned"
    end
    redirect_to collection_path, notice: "#{notice}"
  end

  batch_action :add_task, if: proc {current_user.admin_write?}, id:"add-tasks", form: -> {{
    "Name": :text,
    "Project": Project.pluck(:name, :id),
    "Task Type": TaskType.pluck(:name, :id),
    "Start Date": :datepicker,
    "Due Date": :datepicker,
    "Assign Users": :text,
    "Progress": :number,
    "Description": :textarea
  }} do |ids, inputs|
    user_ids = inputs["Assign Users"].split(',').map(&:to_i) rescue []
    Facility.where(id: ids).each do |facility|
      facility.facility_projects.where(project_id: inputs['Project']).each do |facility_project|
        facility_project.tasks.create!(text: inputs['Name'], task_type_id: inputs['Task Type'], start_date: inputs['Start Date'], due_date: inputs['Due Date'], progress: inputs['Progress'], notes: inputs['Description'], auto_calculate: false, user_ids: user_ids)
      end
    end
    redirect_to collection_path, notice: "Task added"
  rescue => e
    redirect_to collection_path, flash: {error: e.message}
  end

  batch_action :assign_due_date_and_status, if: proc {current_user.admin_write?}, id:"assign-duedate-status", form: -> {{
    "Project": Project.pluck(:name, :id),
    "Status": Status.pluck(:name, :id),
    "Due Date": :datepicker
  }} do |ids, inputs|
    Project.find_by_id(inputs['Project'])&.facility_projects.where(facility_id: ids).each do |facility_project|
      facility_project.update_columns(status_id: inputs['Status'], due_date: inputs['Due Date'])
    end
    redirect_to collection_path, notice: "Due Date and Status is updated"
  rescue => e
    redirect_to collection_path, flash: {error: e.message}
  end

  batch_action :destroy, if: proc {current_user.admin_delete?}, confirm: "Are you sure you want to delete these Facilities" do |ids|
    deleted = Facility.where(id: ids).destroy_all
    redirect_to collection_path, notice: "Successfully deleted #{deleted.count} Facilities"
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
        failure.html {render :edit}
      end
    end

    def index
      super do |format|
        format.json {send_data collection.to_json, type: :json, disposition: "attachment"}
      end
    end

    def scoped_collection
      super.includes(:facility_group)
    end
  end

  filter :creator_id, as: :select, collection: -> {User.admin.where.not(last_name: ['', nil]).or(User.admin.where.not(first_name: [nil, ''])).map{|u| ["#{u.first_name} #{u.last_name}", u.id]}}
  filter :facility_group
  filter :facility_name
  filter :address
  filter :point_of_contact
  filter :email
  filter :phone_number
  filter :status, label: 'State', as: :select, collection: Facility.statuses
  filter :tasks_text, as: :string, label: "Task Name"
  filter :tasks_task_type_id, as: :select, collection: -> {TaskType.pluck(:name, :id)}, label: 'Task Type'
  filter :facility_projects_status_id, as: :select, collection: -> {Status.pluck(:name, :id)}, label: 'Project Status'
  filter :projects
  remove_filter :creator
  remove_filter :country_code
  remove_filter :tasks
  remove_filter :comments
  remove_filter :created_at
  remove_filter :updated_at
  remove_filter :lat
  remove_filter :lng
  remove_filter :facility_projects

end
