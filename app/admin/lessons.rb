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
      :user_id, 
      :lesson_stage_id,
      lesson_files: [],
      user_ids: [],
      sub_task_ids: [],
      sub_issue_ids: [],
      sub_risk_ids: [],
      facility_project_attributes: [
        :id,
        :project_id,
        :facility_id
      ]
    ]
  end

  index do
    div id: '__privileges', 'data-privilege': "#{current_user.admin_privilege}"
    selectable_column if current_user.admin_delete?
    column :title
    column "Category", :task_type, nil, sortable: 'task_types.name' do |lesson|
      if current_user.admin_write?
        link_to "#{lesson.task_type.name}", "#{edit_admin_task_type_path(lesson.task_type)}" if lesson.task_type.present?
      else
        "<span>#{lesson.task_type&.name}</span>".html_safe
      end
    end
    column "Stage", :lesson_stage, nil, sortable: 'lesson_stages.name' do |lesson|
      if current_user.admin_write?
        link_to "#{lesson.lesson_stage.name}", "#{edit_admin_lesson_stage_path(lesson.lesson_stage)}" if lesson.lesson_stage.present?
      else
        "<span>#{lesson.lesson_stage&.name}</span>".html_safe
      end
    end
    column :description, sortable: false
    column "Files" do |lesson|
      lesson.lesson_files.map do |file|
        next if file.nil? || !file.blob.filename.instance_variable_get("@filename").present?
        if current_user.admin_write?
          if file.blob.content_type == "text/plain"
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
        lesson.users
      else
        "<span>#{lesson.users.map(&:full_name).join(', ')}</span>".html_safe
      end
    end

    actions defaults: false do |lesson|
      item "Edit", edit_admin_lesson_path(lesson), title: 'Edit', class: "member_link edit_link" if current_user.admin_write?
      item "Delete", admin_lesson_path(lesson), title: 'Delete', class: "member_link delete_link", 'data-confirm': 'Are you sure you want to delete this?', method: 'delete' if current_user.admin_delete?
      item "Successes", admin_lesson_details_path(q: {lesson_id_eq: lesson.id, detail_type_equals: 'success'} ), class: "member_link edit_link"
      item "Failures", admin_lesson_details_path(q: {lesson_id_eq: lesson.id, detail_type_equals: 'failure'} ), class: "member_link edit_link"
      item "Best Practices", admin_lesson_details_path(q: {lesson_id_eq: lesson.id, detail_type_equals: 'best_practices'} ), class: "member_link edit_link"
    end
  end


  form do |f|
    f.semantic_errors *f.object.errors.keys
    div id: 'direct-upload-url', "data-direct-upload-url": "#{rails_direct_uploads_url}"

    tabs do
      tab 'Lesson Info' do
        f.inputs 'Basic Details' do
          f.input :id, input_html: { value: f.object.id }, as: :hidden
          f.input :title, label: 'Title'
          f.input :description
          div id: 'facility_projects' do
            f.inputs for: [:facility_project, f.object.facility_project || FacilityProject.new] do |fp|
              fp.input :project_id, label: 'Program', as: :select, collection: Project.all.map{|p| [p.name, p.id]}, include_blank: false
              fp.input :facility_id, label: 'Project', as: :select, collection: Facility.all.map{|p| [p.facility_name, p.id]}, include_blank: false
            end
          end
          f.input :task_type, label: 'Category', include_blank: false
          f.input :lesson_stage, label: 'Stage', input_html: {class: "select2"}, include_blank: true
        end
      end

      tab 'Assignments' do
        f.inputs 'Assign Users' do
          f.input :users, label: 'Assigned Users', as: :select, collection: User.active.map{|u| [u.full_name, u.id]}, input_html: {class: "select2"}
          div id: 'projects_users-tab'
        end
      end


      tab 'Files & Links' do
        f.inputs 'Upload Files and Links' do
          div id: 'uploaded-task-files', 'data-files': "#{f.object.files_as_json}"
          f.input :lesson_files
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
    def scoped_collection
      super.includes(:task_type, :lesson_stage, :project, :facility, :user, :lesson_details)
    end
  end

  batch_action :destroy, if: proc {current_user.admin_delete?}, confirm: "Are you sure you want to delete these Lessons?" do |ids|
    deleted = Lesson.where(id: ids).destroy_all
    redirect_to collection_path, notice: "Successfully deleted #{deleted.count} Lessons"
  end

  filter :title
  filter :lesson_details_finding, as: :string, label: 'Finding'
  filter :lesson_details_recommendation, as: :string, label: 'Recommendation'

  filter :task_type, label: 'Category'
  filter :task_stage, label: 'Stage'
  filter :facility_project_project_id, as: :select, collection: -> {Project.pluck(:name, :id)}, label: 'Program'
  filter :facility_project_facility_facility_name, as: :string, label: 'Project'
  filter :users_email, as: :string, label: "Email", input_html: {id: '__users_filter_emails'}
  filter :users, as: :select, collection: -> {User.where.not(last_name: ['', nil]).or(User.where.not(first_name: [nil, ''])).map{|u| ["#{u.first_name} #{u.last_name}", u.id]}}, label: 'Added By', input_html: {multiple: true, id: '__users_filters'}
  filter :id, as: :select, collection: -> {[current_user.admin_privilege]}, input_html: {id: '__privileges_id'}, include_blank: false
  
end