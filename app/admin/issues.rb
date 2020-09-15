ActiveAdmin.register Issue do
  menu priority: 10
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
    column "Assigned To", :users do |issue|
      if current_user.admin_write?
        issue.users
      else
        "<span>#{issue.users.map(&:full_name).join(', ')}</span>".html_safe
      end
    end
    column "Description", :notes, sortable: false
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

    f.inputs 'Basic Details' do
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
      f.input :users, label: 'Assigned Users', as: :select, collection: User.all.map{|u| [u.full_name, u.id]}
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
      f.input :issue_files, as: :file, input_html: {multiple: true}
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
  filter :users, as: :select, collection: -> {User.where.not(last_name: ['', nil]).or(User.where.not(first_name: [nil, ''])).map{|u| ["#{u.first_name} #{u.last_name}", u.id]}}, label: 'Assigned To', input_html: {multiple: true, id: '__users_filters'}
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

    def destroy
      redirect_to '/not_found' and return unless current_user.admin_delete?
      super
    end

    def scoped_collection
      super.includes(:issue_type, :issue_severity, facility_project: [:project, :facility])
    end
  end

end
