ActiveAdmin.register Issue do
  menu priority: 5
  actions :all, except: [:show, :new]

  breadcrumb do
    links = [link_to('Admin', admin_root_path), link_to('Issues', admin_issues_path)]
    if %(show edit).include?(params['action'])
      links << link_to(issue.title, edit_admin_issue_path)
    end
    links
  end

  permit_params do
    permitted = [
      :title,
      :description,
      :due_date,
      :progress,
      :issue_type_id,
      :issue_severity_id,
      :start_date,
      :facility_project_id,
      :auto_calculate,
      issue_files: [],
      user_ids: [],
      sub_task_ids: [],
      sub_issue_ids: [],
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
        :checked
      ]
    ]
  end

  index do
    div id: '__privileges', 'data-privilege': "#{current_user.admin_privilege}"
    selectable_column if current_user.admin_delete?
    column :title
    column :issue_type, nil, sortable: 'issue_types.name' do |issue|
      if current_user.admin_write?
        link_to "#{issue.issue_type.name}", "#{edit_admin_issue_type_path(issue.issue_type)}" if issue.issue_type.present?
      else
        "<span>#{issue.issue_type&.name}</span>".html_safe
      end
    end
    column :issue_severity, nil, sortable: 'issue_severities.name' do |issue|
      if current_user.admin_write?
        link_to "#{issue.issue_severity.name}", "#{edit_admin_issue_severity_path(issue.issue_severity)}" if issue.issue_severity.present?
      else
        "<span>#{issue.issue_severity&.name}</span>".html_safe
      end
    end
    column :progress
    column :start_date
    column "Estimated Completion Date", :due_date
    column :project, nil, sortable: 'projects.name' do |issue|
      if current_user.admin_write?
        link_to "#{issue.project.name}", "#{edit_admin_project_path(issue.project)}" if issue.project.present?
      else
        "<span>#{issue.project&.name}</span>".html_safe
      end
    end
    column :facility, nil, sortable: 'facilities.facility_name' do |issue|
      if current_user.admin_write?
        link_to "#{issue.facility.facility_name}", "#{edit_admin_facility_path(issue.facility)}" if issue.facility.present?
      else
        "<span>#{issue.facility&.facility_name}</span>".html_safe
      end
    end
    column "Assigned To", :users do |issue|
      if current_user.admin_write?
        issue.users
      else
        "<span>#{issue.users.map(&:full_name).join(', ')}</span>".html_safe
      end
    end
    column :description, sortable: false
    column "Files" do |issue|
      issue.issue_files.map do |file|
        if current_user.admin_write?
          link_to "#{file.blob.filename}", "#{Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true)}", target: '_blank'
        else
          "<span>#{file.blob.filename}</span>".html_safe
        end
      end
    end
    actions defaults: false do |issue|
      item "Edit", edit_admin_issue_path(issue), title: 'Edit', class: "member_link edit_link" if current_user.admin_write?
      item "Delete", admin_issue_path(issue), title: 'Delete', class: "member_link delete_link", 'data-confirm': 'Are you sure you want to delete this?', method: 'delete' if current_user.admin_delete?
    end
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    div id: 'direct-upload-url', "data-direct-upload-url": "#{rails_direct_uploads_url}"
    f.inputs 'Basic Details' do
      f.input :id, input_html: { value: f.object.id }, as: :hidden
      f.input :title
      div id: 'facility_projects' do
        f.inputs for: [:facility_project, f.object.facility_project || FacilityProject.new] do |fp|
            fp.input :project_id, label: 'Project', as: :select, collection: Project.all.map{|p| [p.name, p.id]}, include_blank: false
            fp.input :facility_id, label: 'Facility', as: :select, collection: Facility.all.map{|p| [p.facility_name, p.id]}, include_blank: false
        end
      end
      f.input :issue_type
      f.input :issue_severity
      f.input :start_date, as: :datepicker
      f.input :due_date, as: :datepicker, label: 'Estimated Completion Date'
      f.input :users, label: 'Assigned Users', as: :select, collection: User.active.map{|u| [u.full_name, u.id]}
      div id: 'projects_users-tab'
      f.input :progress
      div id: 'progress_slider-tab'
      f.input :auto_calculate
      f.has_many :checklists, heading: 'Checklist Items', allow_destroy: true do |c|
        c.input :checked, label: '', input_html: {class: 'checklist_item_checked', disabled: !c.object.text&.strip}
        c.input :text, input_html: {class: 'checklist_item_text'}
        c.input :user_id, as: :select, label: 'Assigned To', collection: User.where(id: f.object.user_ids).map{|u| [u.full_name, u.id]}, input_html: {class: 'checklist_user'}
      end
      f.input :description
      div id: 'uploaded-task-files', 'data-files': "#{f.object.files_as_json}"
      f.input :issue_files
      f.input :sub_tasks, label: 'Related Tasks', as: :select, collection: Task.all.map{|u| [u.text, u.id]}, input_html: {multiple: true}
      f.input :sub_issues, label: 'Related Issues', as: :select, collection: Issue.all.map{|u| [u.title, u.id]}, input_html: {multiple: true}
      div id: 'related_tasks-issues-tab'
    end
    f.actions
  end

  batch_action :destroy, if: proc {current_user.admin_delete?}, confirm: "Are you sure you want to delete these Issues?" do |ids|
    deleted = Issue.where(id: ids).destroy_all
    redirect_to collection_path, notice: "Successfully deleted #{deleted.count} Issues"
  end

  filter :title
  filter :issue_type
  filter :issue_severity
  filter :progress
  filter :start_date
  filter :due_date, label: 'Estimated Completion Date'
  filter :facility_project_project_id, as: :select, collection: -> {Project.pluck(:name, :id)}, label: 'Project'
  filter :facility_project_facility_facility_name, as: :string, label: 'Facility'
  filter :users_email, as: :string, label: "Email", input_html: {id: '__users_filter_emails'}
  filter :users, as: :select, collection: -> {User.where.not(last_name: ['', nil]).or(User.where.not(first_name: [nil, ''])).map{|u| ["#{u.first_name} #{u.last_name}", u.id]}}, label: 'Assigned To', input_html: {multiple: true, id: '__users_filters'}
  filter :id, as: :select, collection: -> {[current_user.admin_privilege]}, input_html: {id: '__privileges_id'}, include_blank: false

  controller do
    before_action :check_readability, only: [:index, :show]
    before_action :check_writeability, only: [:new, :edit, :update, :create]
    before_action :handle_files, only: [:update, :create]

    def check_readability
      redirect_to '/not_found' and return unless current_user.admin_read?
    end

    def check_writeability
      redirect_to '/not_found' and return unless current_user.admin_write?
    end

    def handle_files
      resource.manipulate_files(params)
      params[:issue].delete(:issue_files)
    end

    def destroy
      redirect_to '/not_found' and return unless current_user.admin_delete?
      super
    rescue ActiveRecord::StatementInvalid
      flash[:error] = "Not able to delete this! Violates foreign key constraint."
      redirect_back fallback_location: root_path
    end

    def scoped_collection
      super.includes(:issue_type, :issue_severity, facility_project: [:project, :facility])
    end
  end

end
