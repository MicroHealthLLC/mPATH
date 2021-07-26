ActiveAdmin.register Task do
  menu priority: 4
  actions :all, except: [:show]

  breadcrumb do
    links = [link_to('Admin', admin_root_path), link_to('Tasks', admin_tasks_path)]
    if %(show edit).include?(params['action'])
      links << link_to(task.text, edit_admin_task_path)
    end
    links
  end

  permit_params do
    permitted = [
      :text,
      :description,
      :due_date,
      :progress,
      :task_type_id,
      :task_stage_id,
      :start_date,
      :auto_calculate,
      task_files: [],
      file_links: [],
      user_ids: [],
      sub_task_ids: [],
      sub_issue_ids: [],
      sub_risk_ids: [],
      facility_project_attributes: [
        :id,
        :project_id,
        :facility_id
      ],
      checklists_attributes: [
        :id,
        :_destroy,
        :text,
        :user_id,
        :due_date,
        :checked
      ]
    ]
  end

  index do
    div id: '__privileges', 'data-privilege': "#{current_user.admin_privilege}"
    selectable_column if current_user.admin_write? || current_user.admin_delete?
    column "Name", :text
    column "Category", :task_type, nil, sortable: 'task_types.name' do |task|
      if current_user.admin_write?
        link_to "#{task.task_type.name}", "#{edit_admin_task_type_path(task.task_type)}" if task.task_type.present?
      else
        "<span>#{task.task_type&.name}</span>".html_safe
      end
    end
    column "Stage", :task_stage, nil, sortable: 'task_stages.name' do |task|
      if current_user.admin_write?
        link_to "#{task.task_stage.name}", "#{edit_admin_task_stage_path(task.task_stage)}" if task.task_stage.present?
      else
        "<span>#{task.task_stage&.name}</span>".html_safe
      end
    end
    column :start_date
    column :due_date
    column :progress
    column :description, sortable: false
    column "Files" do |task|
      task.task_files.map do |file|
        next if file.nil? || !file.blob.filename.instance_variable_get("@filename").present?
        if current_user.admin_write?
          if file.blob.content_type == "text/plain" && task.valid_url?(file.blob.filename.instance_variable_get("@filename"))
            link_to file.blob.filename.instance_variable_get("@filename"), file.blob.filename.instance_variable_get("@filename"), target: '_blank'
          else
            link_to "#{file.blob.filename}", "#{Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true)}", target: '_blank'
          end
        else
          "<span>#{file.blob.filename}</span>".html_safe
        end
      end
    end
    column "Program", :project, nil, sortable: 'projects.name' do |task|
      if current_user.admin_write?
        link_to "#{task.project.name}", "#{edit_admin_project_path(task.project)}" if task.project.present?
      else
        "<span>#{task.project&.name}</span>".html_safe
      end
    end
    column "Project", :facility, nil, sortable: 'facilities.facility_name' do |task|
      if current_user.admin_write?
        link_to "#{task.facility.facility_name}", "#{edit_admin_facility_path(task.facility)}" if task.facility.present?
      else
        "<span>#{task.facility&.facility_name}</span>".html_safe
      end
    end
    column "Assigned To", :users do |task|
      if current_user.admin_write?
        task.users
      else
        "<span>#{task.users.map(&:full_name).join(', ')}</span>".html_safe
      end
    end
    actions defaults: false do |task|
      item "Edit", edit_admin_task_path(task), title: 'Edit', class: "member_link edit_link" if current_user.admin_write?
      item "Delete", admin_task_path(task), title: 'Delete', class: "member_link delete_link", 'data-confirm': 'Are you sure you want to delete this?', method: 'delete' if current_user.admin_delete?
    end
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    div id: 'direct-upload-url', "data-direct-upload-url": "#{rails_direct_uploads_url}"

    tabs do
      tab 'Task Info' do
        f.inputs 'Basic Details' do
          f.input :id, input_html: { value: f.object.id }, as: :hidden
          f.input :text, label: 'Name'
          f.input :description
          div id: 'facility_projects' do
            f.inputs for: [:facility_project, f.object.facility_project || FacilityProject.new] do |fp|
                fp.input :project_id, label: 'Program', as: :select, collection: Project.all.map{|p| [p.name, p.id]}, include_blank: false
                fp.input :facility_id, label: 'Project', as: :select, collection: Facility.all.map{|p| [p.facility_name, p.id]}, include_blank: false
            end
          end
          f.input :task_type, label: 'Category', include_blank: false
          f.input :task_stage, label: 'Stage', input_html: {class: "select2"}, include_blank: true
          f.input :start_date, as: :datepicker
          f.input :due_date, as: :datepicker
        end
      end

      tab 'Assignments' do
        f.inputs 'Assign Users' do
          f.input :users, label: 'Assigned Users', as: :select, collection: User.active.map{|u| [u.full_name, u.id]}, input_html: {class: "select2"}
          div id: 'projects_users-tab'
        end
      end

      tab 'Checklist' do
        f.inputs 'Progress and Checklist' do
          f.input :progress, as: :hidden
          div id: 'progress_slider-tab'
          f.input :auto_calculate
          f.has_many :checklists, heading: 'Checklist Items', allow_destroy: true do |c|
            c.input :checked, label: '', input_html: {class: 'checklist_item_checked', disabled: !c.object.text&.strip}
            c.input :text, input_html: {class: 'checklist_item_text'}
            c.input :user_id, as: :select, label: 'Assigned To', collection: User.active.map{|u| [u.full_name, u.id]}, input_html: {class: 'select2 checklist_user'}
            c.input :due_date, as: :datepicker
          end
        end
      end

      tab 'Files & Links' do
        f.inputs 'Upload Files and Links' do
          div id: 'uploaded-task-files', 'data-files': "#{f.object.files_as_json}"
          f.input :task_files
          div id: 'uploaded-task-links', 'data-links': "#{f.object.links_as_json}"
          f.input :file_links, label: 'Add Links'
        end
      end

      tab 'Related' do
        f.inputs 'Releated Items' do
          f.input :sub_tasks, label: 'Related Tasks', as: :select, collection: Task.all.map{|u| [u.text, u.id]}, input_html: {class: "select2"}
          f.input :sub_issues, label: 'Related Issues', as: :select, collection: Issue.all.map{|u| [u.title, u.id]}, input_html: {class: "select2"}
          f.input :sub_risks, label: 'Related Risks', as: :select, collection: Risk.all.map{|u| [u.risk_description, u.id]}, input_html: {class: "select2"}
          div id: 'related_tasks-issues-tab'
        end
      end
    end
    f.actions
  end

  batch_action :destroy, if: proc {current_user.admin_delete?}, confirm: "Are you sure you want to delete these Tasks?" do |ids|
    deleted = Task.where(id: ids).destroy_all
    redirect_to collection_path, notice: "Successfully deleted #{deleted.count} Tasks"
  end

  batch_action :add_checklist_to_tasks, if: proc {current_user.admin_write?}, form: -> {{
    "Title": :text,
    "Checked": :checkbox,
    "User Assigned": User.active.map{|u| [u.full_name, u.id]},
    "Due Date": :datepicker
  }} do |ids, inputs|
    Task.where(id: ids).each do |task|
      task.checklists.create(text: inputs['Title'], checked: inputs['Checked'], user_id: inputs['User Assigned'], due_date: inputs['Due Date'])
    end
    redirect_to collection_path, notice: "Successfully created Task checklists"
  end

  filter :text, label: 'Name'
  filter :task_type, label: 'Category'
  filter :task_stage, label: 'Stage'
  filter :start_date
  filter :due_date
  filter :facility_project_project_id, as: :select, collection: -> {Project.pluck(:name, :id)}, label: 'Program'
  filter :facility_project_facility_facility_name, as: :string, label: 'Project'
  filter :users_email, as: :string, label: "Email", input_html: {id: '__users_filter_emails'}
  filter :users, as: :select, collection: -> {User.where.not(last_name: ['', nil]).or(User.where.not(first_name: [nil, ''])).map{|u| ["#{u.first_name} #{u.last_name}", u.id]}}, label: 'Assigned To', input_html: {multiple: true, id: '__users_filters'}
  filter :checklists_user_id, as: :select, collection: -> {User.where.not(last_name: ['', nil]).or(User.where.not(first_name: [nil, ''])).map{|u| ["#{u.first_name} #{u.last_name}", u.id]}}, label: 'Checklist Item assigned to', input_html: {multiple: true, id: '__checklist_users_filters'}
  filter :progress
  filter :id, as: :select, collection: -> {[current_user.admin_privilege]}, input_html: {id: '__privileges_id'}, include_blank: false

  controller do
    before_action :check_readability, only: [:index, :show]
    before_action :check_writeability, only: [:new, :edit, :update, :create]

    def check_readability
      redirect_to '/not_found' and return unless current_user.admin_read?
    end

    def check_writeability
      redirect_to '/not_found' and return unless current_user.admin_write?
    end

    def create
      build_resource
      handle_links
      handle_files
      super
    end

    def update
      handle_links
      handle_files
      super
    end

    def handle_files
      resource.manipulate_files(params) if resource.present?
      params[:task].delete(:task_files)
    end

    def handle_links
      resource.manipulate_links(params) if resource.present?
      params[:task].delete(:file_links)
    end

    def destroy
      redirect_to '/not_found' and return unless current_user.admin_delete?
      super
    rescue ActiveRecord::StatementInvalid
      flash[:error] = "Not able to delete this! Violates foreign key constraint."
      redirect_back fallback_location: root_path
    end

    def scoped_collection
      super.includes(:task_type, :task_stage, facility_project: [:project, :facility])
    end
  end

end
