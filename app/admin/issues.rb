ActiveAdmin.register Issue do
  menu priority: 5
  actions :all, except: [:show]

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
      :task_type_id,
      :description,
      :due_date,
      :progress,
      :issue_type_id,
      :issue_stage_id,
      :issue_severity_id,
      :start_date,
      :facility_project_id,
      :auto_calculate,
      :project_contract_id,
      issue_files: [],
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
        :checked,
        :due_date
      ]
    ]
  end

  index do
    div id: '__privileges', 'data-privilege': "#{current_user.admin_privilege}"
    selectable_column if current_user.admin_write? || current_user.admin_delete?
    column :title
    column :task_type, nil, sortable: 'task_types.name' do |issue|
      if current_user.admin_write?
        link_to "#{issue.task_type.name}", "#{edit_admin_task_type_path(issue.task_type)}" if issue.task_type.present?
      else
        "<span>#{issue.task_type&.name}</span>".html_safe
      end
    end
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
    column :issue_stage, nil, sortable: 'issue_stages.name' do |issue|
      if current_user.admin_write?
        link_to "#{issue.issue_stage.name}", "#{edit_admin_issue_stage_path(issue.issue_stage)}" if issue.issue_stage.present?
      else
        "<span>#{issue.issue_stage&.name}</span>".html_safe
      end
    end
    column :progress
    column :start_date
    column "Estimated Completion Date", :due_date
    column "Contract", :contract_project_data, sortable: 'contract_project_data.name' do |issue|
      "<span>#{issue.contract_project_data&.name}</span>".html_safe
    end
    column "Program", :project, nil, sortable: 'projects.name' do |issue|
      if current_user.admin_write?
        link_to "#{issue.project.name}", "#{edit_admin_project_path(issue.project)}" if issue.project.present?
      else
        "<span>#{issue.project&.name}</span>".html_safe
      end
    end
    column "Project", :facility, nil, sortable: 'facilities.facility_name' do |issue|
      if current_user.admin_write? && issue.facility && issue.facility.is_portfolio
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
    column "Files & Links" do |issue|
      issue.issue_files.map do |file|
        next if file.nil? || !file.blob.filename.instance_variable_get("@filename").present?
        if current_user.admin_write?
          if file.blob.content_type == "text/plain" && issue.valid_url?(file.blob.filename.instance_variable_get("@filename"))
            link_to file.blob.filename.instance_variable_get("@filename"), file.blob.filename.instance_variable_get("@filename"), target: '_blank'
          else
            link_to "#{file.blob.filename}", "#{Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true)}", target: '_blank'
          end
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
    f.semantic_errors *f.object.errors
    div id: 'direct-upload-url', "data-direct-upload-url": "#{rails_direct_uploads_url}"

    tabs do
      tab 'Issue Info' do
        f.inputs 'Basic Details' do
          f.input :id, input_html: { value: f.object.id }, as: :hidden
          f.input :title
          f.input :task_type, include_blank: true
          f.input :description
          if f.object.is_contract_resource?
            project_contract_options = []
            Project.includes([{project_contracts: :contract_project_datum }]).in_batches(of: 1000) do |projects|
              projects.each do |project|
                project_contract_options << [project.name, project.id, {disabled: true}]
                project.project_contracts.each do |pc|
                  project_contract_options << ["&nbsp;&nbsp;&nbsp;#{pc.contract_project_datum.name}".html_safe, pc.id]
                end
              end
            end
            
            f.input :project_contract_id, label: 'Conract', as: :select, collection: project_contract_options, input_html: {class: "select2"}
          else
            # div id: 'facility_projects' do
            #   f.inputs for: [:facility_project, f.object.facility_project || FacilityProject.new] do |fp|
            #     fp.input :project_id, label: 'Program', as: :select, collection: Project.pluck(:name, :id),
            #                           include_blank: false
            #     fp.input :facility_id, label: 'Project', as: :select, collection: Facility.pluck(:facility_name, :id),
            #                           include_blank: false
            #   end
            # end
            facility_project_options = []
          
            Project.includes([{facility_projects: :facility }]).in_batches(of: 1000) do |projects|
              projects.each do |project|
                facility_project_options << [project.name, project.id, {disabled: true}]
                project.facility_projects.each do |fp|
                  facility_project_options << ["&nbsp;&nbsp;&nbsp;#{fp.facility.facility_name}".html_safe, fp.id]
                end
              end
            end
            
            f.input :facility_project_id, label: 'Project', as: :select, collection: facility_project_options, input_html: {class: "select2"}
          end
          f.input :issue_type, include_blank: false
          f.input :issue_severity, include_blank: false
          f.input :issue_stage, label: 'Stage', input_html: {class: "select2"}, include_blank: true
          f.input :start_date, as: :datepicker
          f.input :due_date, as: :datepicker, label: 'Estimated Completion Date'
        end
      end

      tab 'Assignments' do
        f.inputs 'Assign Users' do
          f.input :users, label: 'Assigned Users', as: :select, collection: User.active.map{|u| [u.full_name, u.id]},  input_html: {class: "select2"}
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
            c.input :due_date, input_html: {style: "width: 100%"}
          end
        end
      end

      tab 'Files & Links' do
        f.inputs 'Upload Files and Links' do
          div id: 'uploaded-task-files', 'data-files': "#{f.object.files_as_json}"
          f.input :issue_files
          div id: 'uploaded-task-links', 'data-links': "#{f.object.links_as_json}"
          f.input :file_links, label: 'Add Links', placeholder: 'Input link, then "Enter"'
        end
      end

      tab 'Related' do
        f.inputs 'Releated Items' do
          f.input :sub_tasks, label: 'Related Tasks', as: :select, collection: Task.all.map{|u| [u.text, u.id]},  input_html: {class: "select2"}
          f.input :sub_issues, label: 'Related Issues', as: :select, collection: Issue.all.map{|u| [u.title, u.id]},  input_html: {class: "select2"}
          f.input :sub_risks, label: 'Related Risks', as: :select, collection: Risk.all.map{|u| [u.risk_description, u.id]},  input_html: {class: "select2"}
          div id: 'related_tasks-issues-tab'
        end
      end
    end
    f.actions
  end

  batch_action :destroy, if: proc {current_user.admin_delete?}, confirm: "Are you sure you want to delete these Issues?" do |ids|
    deleted = Issue.where(id: ids).destroy_all
    redirect_to collection_path, notice: "Successfully deleted #{deleted.count} Issues"
  end

  batch_action :add_checklist_to_issues, if: proc {current_user.admin_write?}, form: -> {{
    "Title": :text,
    "Checked": :checkbox,
    "User Assigned": User.active.map{|u| [u.full_name, u.id]},
    "Due Date": :datepicker
  }} do |ids, inputs|
    Issue.where(id: ids).each do |issue|
      issue.checklists.create(text: inputs['Title'], checked: inputs['Checked'], user_id: inputs['User Assigned'], due_date: inputs['Due Date'])
    end
    redirect_to collection_path, notice: "Successfully created Issue checklists"
  end

  csv do
    column(:title)
    column(:task_type) { |issue| issue.task_type&.name }
    column(:issue_type) { |issue| issue.issue_type&.name }
    column(:issue_severity) { |issue| issue.issue_severity&.name }
    column(:issue_stage) { |issue| issue.issue_stage&.name }
    column(:progress)
    column(:start_date) { |issue| issue.start_date&.strftime('%d/%b/%Y') }
    column(:due_date) { |issue| issue.due_date&.strftime('%d/%b/%Y') }
    column(:issue_files) { |issue| issue.issue_files&.map { |f| f.blob.filename.instance_variable_get('@filename') } }
    column('Program') { |issue| issue.project&.name }
    column('Project') { |issue| issue.facility&.facility_name }
    column(:users) { |issue| issue.users&.map(&:full_name) }
  end

  filter :title
  filter :task_type
  filter :issue_type
  filter :issue_severity
  filter :issue_stage
  filter :progress
  filter :start_date
  filter :due_date, label: 'Estimated Completion Date'
  filter :facility_project_project_id, as: :select, collection: -> { Project.pluck(:name, :id) },
                                       label: 'Program', input_html: { multiple: true }
  filter :facility_project_facility_id, as: :select, collection: -> { Facility.pluck(:facility_name, :id) },
                                        label: 'Project', input_html: { multiple: true }
  filter :users_email, as: :string, label: "Email", input_html: {id: '__users_filter_emails'}
  filter :users, as: :select, collection: -> {User.where.not(last_name: ['', nil]).or(User.where.not(first_name: [nil, ''])).map{|u| ["#{u.first_name} #{u.last_name}", u.id]}}, label: 'Assigned To', input_html: {multiple: true}
  filter :checklists_user_id, as: :select, collection: -> {User.where.not(last_name: ['', nil]).or(User.where.not(first_name: [nil, ''])).map{|u| ["#{u.first_name} #{u.last_name}", u.id]}}, label: 'Checklist Item assigned to', input_html: {multiple: true}
  filter :exclude_inactive, as: :check_boxes, collection: [['Exclude Inactive Items', false]], label: ''
  filter :id, as: :select, collection: -> {[current_user.admin_privilege]}, input_html: {id: '__privileges_id'}, include_blank: false

  controller do
    before_action :exclude_inactive_items, only: [:index]
    before_action :check_readability, only: [:index, :show]
    before_action :check_writeability, only: [:new, :edit, :update, :create]

    def exclude_inactive_items
      return unless params.keys == ["controller", "action"]
      extra_params = { "q" => { "exclude_inactive_in" => ["true"] }}
      params.merge! extra_params
      request.query_parameters.merge! extra_params
    end

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
      params[:issue].delete(:issue_files)
    end

    def handle_links
      resource.manipulate_links(params) if resource.present?
      params[:issue].delete(:file_links)
    end

    def destroy
      redirect_to '/not_found' and return unless current_user.admin_delete?
      super
    rescue ActiveRecord::StatementInvalid
      flash[:error] = "Not able to delete this! Violates foreign key constraint."
      redirect_back fallback_location: root_path
    end

    def scoped_collection
      super.includes(:contract_project_data, :task_type, :issue_type, :issue_severity, :issue_stage, :facility, facility_project: [:project, :facility])
    end
  end

end
