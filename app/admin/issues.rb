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
      issue_files: []
    ]
  end

  index do
    selectable_column
    column :title
    column :issue_type, nil, sortable: 'issue_types.name' do |issue|
      raw "<a href='#{edit_admin_issue_type_path(issue.issue_type)}'>#{issue.issue_type.name}</a>" if issue.issue_type.present?
    end
    column :issue_severity, nil, sortable: 'issue_severities.name' do |issue|
      raw "<a href='#{edit_admin_issue_severity_path(issue.issue_severity)}'>#{issue.issue_severity.name}</a>" if issue.issue_severity.present?
    end
    column :progress
    column :start_date
    column :due_date
    column "Description", :notes, sortable: false
    column "Files" do |issue|
      issue.issue_files.map do |file|
        raw "<a href='#{Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true)}' target='_blank'>#{file.blob.filename}</a>"
      end
    end
    actions

  end

  form do |f|
    f.semantic_errors *f.object.errors.keys

    f.inputs 'Basic Details' do
      f.input :title
      f.input :issue_type
      f.input :issue_severity
      f.input :start_date, as: :datepicker
      f.input :due_date, as: :datepicker
      f.input :progress
      div id: 'progress_slider-tab'
      f.input :description
      f.input :issue_files, as: :file, input_html: {multiple: true}
    end
    f.actions
  end

  filter :title
  filter :issue_type
  filter :issue_severity
  filter :progress
  filter :start_date
  filter :due_date

  controller do
    def scoped_collection
      super.includes(:issue_type, :issue_severity, facility_project: [:project, :facility])
    end
  end

end
