ActiveAdmin.register Task do
  menu priority: 8
  actions :all, except: [:show, :new]

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
      :notes,
      :due_date,
      :progress,
      :task_type_id,
      :start_date,
      task_files: [],
      facility_project_attributes: [
        :id,
        :project_id,
        :facility_id
      ]
    ]
  end

  index do
    div id: '__privileges', 'data-privilege': "#{current_user.admin_privilege}"
    selectable_column if current_user.admin_write?
    column "Name", :text
    column :task_type, nil, sortable: 'task_types.name' do |task|
      raw "<a href='#{edit_admin_task_type_path(task.task_type)}'>#{task.task_type.name}</a>" if task.task_type.present?
    end
    column :start_date
    column :due_date
    column :progress
    column "Description", :notes, sortable: false
    column "Files" do |task|
      task.task_files.map do |file|
        raw "<a href='#{Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true)}' target='_blank'>#{file.blob.filename}</a>"
      end
    end
    column :project, nil, sortable: 'projects.name' do |task|
      raw "<a href='#{edit_admin_project_path(task.project)}'>#{task.project.name}</a>" if task.project.present?
    end
    column :facility, nil, sortable: 'facilities.facility_name' do |task|
      raw "<a href='#{edit_admin_facility_path(task.facility)}'>#{task.facility.facility_name}</a>" if task.facility.present?
    end
    actions defaults: false do |task|
      item "Edit", edit_admin_task_path(task), title: 'Edit', class: "member_link edit_link" if current_user.admin_write?
      item "Delete", admin_task_path(task), title: 'Delete', class: "member_link delete_link", 'data-confirm': 'Are you sure you want to delete this?', method: 'delete' if current_user.admin_delete?
    end
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys

    f.inputs 'Basic Details' do
      f.input :text, label: 'Name'
      f.inputs for: [:facility_project, f.object.facility_project || FacilityProject.new] do |fp|
          fp.input :project_id, label: 'Project', as: :select, collection: Project.all.map{|p| [p.name, p.id]}
          fp.input :facility_id, label: 'Facility', as: :select, collection: Facility.all.map{|p| [p.facility_name, p.id]}
      end
      f.input :task_type
      f.input :start_date, as: :datepicker
      f.input :due_date, as: :datepicker
      f.input :progress
      div id: 'progress_slider-tab'
      f.input :notes, label: 'Description'
      f.input :task_files, as: :file, input_html: { multiple: true }
    end
    f.actions
  end

  batch_action :destroy, if: proc {current_user.admin_delete?}, confirm: "Are you sure you want to delete these Tasks?" do |ids|
    deleted = Task.where(id: ids).destroy_all
    redirect_to collection_path, notice: "Successfully deleted #{deleted.count} Tasks"
  end

  filter :text, label: 'Name'
  filter :task_type
  filter :start_date
  filter :due_date
  filter :facility_project_project_id, as: :select, collection: -> {Project.pluck(:name, :id)}, label: 'Project'
  filter :facility_project_facility_facility_name, as: :string, label: 'Facility'
  filter :progress

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
      super.includes(:task_type, facility_project: [:project, :facility])
    end
  end

end
