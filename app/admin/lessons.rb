ActiveAdmin.register Lesson do
  menu priority: 9
  actions :all, except: [:show]

  breadcrumb do
    links = [link_to('Admin', admin_root_path), link_to('Lessons', admin_lessons_path)]
    if %(show edit).include?(params['action'])
      links << link_to(lesson.title, edit_admin_lesson_path)
    end
    links
  end

  permit_params do
    permitted = [
      :title, 
      :description, 
      :date, 
      :task_type_id,  
      :facility_project_id,
      :project_contract_id,
      :user_id, 
      :lesson_stage_id,
      file_links: [],
      lesson_files: [],
      user_ids: [],
      sub_task_ids: [],
      sub_issue_ids: [],
      sub_risk_ids: []
      # facility_project: [
      #   :id,
      #   :project_id,
      #   :facility_id
      # ]
    ]
    permitted
  end

  index do
    div id: '__privileges', 'data-privilege': "#{current_user.admin_privilege}"
    selectable_column if current_user.admin_delete?
    column 'Name', :title
    column :task_type, nil, sortable: 'task_types.name' do |lesson|
      if current_user.admin_write?
        link_to "#{lesson.task_type.name}", "#{edit_admin_task_type_path(lesson.task_type)}" if lesson.task_type.present?
      else
        "<span>#{lesson.task_type&.name}</span>".html_safe
      end
    end
    column "Contract",  sortable: 'contract_project_data.name' do |lesson|
      "<span>#{lesson.contract_project_data&.name}</span>".html_safe
    end
    column "Stage", :lesson_stage, nil, sortable: 'lesson_stages.name' do |lesson|
      if current_user.admin_write?
        link_to "#{lesson.lesson_stage.name}", "#{edit_admin_lesson_stage_path(lesson.lesson_stage)}" if lesson.lesson_stage.present?
      else
        "<span>#{lesson.lesson_stage&.name}</span>".html_safe
      end
    end
    column :description, sortable: false
    column "Files & Links" do |lesson|
      lesson.lesson_files.map do |file|
        next if file.nil? || !file.blob.filename.instance_variable_get("@filename").present?
        if current_user.admin_write?
          if file.blob.content_type == "text/plain" && lesson.valid_url?(file.blob.filename.instance_variable_get("@filename").to_s)
            link_to file.blob.filename.instance_variable_get("@filename"), file.blob.filename.instance_variable_get("@filename"), target: '_blank'
          else
            link_to "#{file.blob.filename}", "#{Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true)}", target: '_blank'
          end
        else
          "<span>#{file.blob.filename}</span>".html_safe
        end
      end
    end
    column "Program", :project, nil, sortable: 'projects.name' do |lesson|
      if current_user.admin_write?
        link_to "#{lesson.project.name}", "#{edit_admin_project_path(lesson.project)}" if lesson.project.present?
        link_to "#{lesson.contract_project.name}", "#{edit_admin_project_path(lesson.contract_project)}" if lesson.contract_project.present?
      else
        "<span>#{lesson.project&.name}</span>".html_safe
      end
    end
    column "Project", :facility, nil, sortable: 'facilities.facility_name' do |lesson|
      if current_user.admin_write?
        link_to "#{lesson.facility.facility_name}", "#{edit_admin_facility_path(lesson.facility)}" if lesson.facility.present?
      else
        "<span>#{lesson.facility&.facility_name}</span>".html_safe
      end
    end
    column "Added By", :users, sortable: 'users.first_name' do |lesson|
      if current_user.admin_write?
        lesson.user
      else
        "<span>#{lesson.user.full_name}</span>".html_safe
      end
    end
    column 'Lesson Details' do |lesson|
      links = []
      if lesson.lesson_details.select{|ld| ld.detail_type == 'success'}.any?
        links << link_to("Successes", admin_lesson_details_path(q: {lesson_id_eq: lesson.id, detail_type_eq: 'success'} ), class: "member_link edit_link")
      end
      if lesson.lesson_details.select{|ld| ld.detail_type == 'failure'}.any?
        links << link_to("Failures", admin_lesson_details_path(q: {lesson_id_eq: lesson.id, detail_type_eq: 'failure'} ), class: "member_link edit_link")
      end
      if lesson.lesson_details.select{|ld| ld.detail_type == 'best_practices'}.any?
        links << link_to("Best Practices", admin_lesson_details_path(q: {lesson_id_eq: lesson.id, detail_type_eq: 'best_practices'} ), class: "member_link edit_link")
      end
      links.join(" ").html_safe  
    end

    actions defaults: false do |lesson|
      item "Edit", edit_admin_lesson_path(lesson), title: 'Edit', class: "member_link edit_link" if current_user.admin_write?
      item "Delete", admin_lesson_path(lesson), title: 'Delete', class: "member_link delete_link", 'data-confirm': 'Are you sure you want to delete this?', method: 'delete' if current_user.admin_delete?
    end
  end


  form do |f|
    f.semantic_errors *f.object.errors.keys
    div id: 'direct-upload-url', "data-direct-upload-url": "#{rails_direct_uploads_url}"

    tabs do
      tab 'Lesson Info' do
        f.inputs 'Basic Details' do
          f.input :id, input_html: { value: f.object.id }, as: :hidden
          f.input :title, label: 'Name'
          f.input :description
          f.input :date, label: 'Date', as: :datepicker
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

          # div id: 'facility_projects' do
          #   f.inputs for: [:facility_project, f.object.facility_project || FacilityProject.new] do |fp|
          #     fp.input :project_id, label: 'Program', as: :select, collection: Project.all.map{|p| [p.name, p.id]}, include_blank: false
          #     fp.input :facility_id, label: 'Project', as: :select, collection: Facility.all.map{|p| [p.facility_name, p.id]}, include_blank: false
          #   end
          # end
          f.input :task_type,  input_html: {class: "select2"}, include_blank: true
          f.input :lesson_stage, label: 'Stage', input_html: {class: "select2"}, include_blank: true
          f.input :user_id, label: 'User', as: :select, collection: User.active.map{|u| [u.full_name, u.id]}, input_html: {class: "select2"}

        end
      end

      # tab 'Assignments' do
      #   f.inputs 'Assign Users' do
      #     f.input :users, label: 'Assigned Users', as: :select, collection: User.active.map{|u| [u.full_name, u.id]}, input_html: {class: "select2"}
      #     div id: 'projects_users-tab'
      #   end
      # end


      tab 'Files & Links' do
        f.inputs 'Upload Files and Links' do
          div id: 'uploaded-task-files', 'data-files': "#{f.object.files_as_json}"
          f.input :lesson_files
          div id: 'uploaded-task-links', 'data-links': "#{f.object.links_as_json}"
          f.input :file_links, label: 'Add Links', placeholder: 'Input link, then "Enter"'
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

  controller do
    
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
      params[:lesson].delete(:lesson_files)
    end

    def handle_links
      resource.manipulate_links(params) if resource.present?
      params[:lesson].delete(:file_links)
    end

    def scoped_collection
      super.includes(:task_type, :lesson_stage, :user, :lesson_details, :contract_project_data, facility_project: [:project, :facility])
    end
  end

  batch_action :destroy, if: proc {current_user.admin_delete?}, confirm: "Are you sure you want to delete these Lessons?" do |ids|
    deleted = Lesson.where(id: ids).destroy_all
    redirect_to collection_path, notice: "Successfully deleted #{deleted.count} Lessons"
  end

  csv do
    column(:title)
    column(:task_type) { |lesson| lesson.task_type&.name }
    column(:lesson_stage) { |lesson| lesson.lesson_stage&.name }
    column(:description)
    column(:lesson_files) { |lesson| lesson.lesson_files&.map { |f| f.blob.filename.instance_variable_get('@filename') } }
    column('Program') { |lesson| lesson.project&.name }
    column('Project') { |lesson| lesson.facility&.facility_name }
    column(:users) { |lesson| lesson.users&.map(&:full_name) }
    column(:lesson_details) { |lesson| lesson.lesson_details&.map(&:detail_type) }
  end

  filter :title, label: 'Name'
  filter :lesson_details_finding, as: :string, label: 'Finding'
  filter :lesson_details_recommendation, as: :string, label: 'Recommendation'

  filter :task_type
  filter :task_stage, label: 'Stage'
  filter :facility_project_project_id, as: :select, collection: -> {Project.pluck(:name, :id)}, label: 'Program'
  filter :facility_project_facility_facility_name, as: :string, label: 'Project'
  filter :users_email, as: :string, label: "Email", input_html: {id: '__users_filter_emails'}
  filter :user, as: :select, collection: -> {User.where.not(last_name: ['', nil]).or(User.where.not(first_name: [nil, ''])).map{|u| ["#{u.first_name} #{u.last_name}", u.id]}}, label: 'Added By', input_html: {multiple: true, id: 'q_user_id'}
  filter :id, as: :select, collection: -> {[current_user.admin_privilege]}, input_html: {id: '__privileges_id'}, include_blank: false
  
end
