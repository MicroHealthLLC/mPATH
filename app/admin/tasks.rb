ActiveAdmin.register Task do
  menu priority: 7
  actions :all, except: [:show, :new]

  permit_params do
    permitted = [
      :text,
      :notes,
      :due_date,
      :progress,
      :task_type_id,
      :start_date,
      :facility_project_id,
      task_files: []
    ]
  end

  index do
    selectable_column
    column "Name", :text
    column :task_type
    column :start_date
    column :due_date
    column :progress
    column :notes
    column "Files" do |task|
      task.task_files.map do |file|
        raw "<a href='#{Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true)}' target='_blank'>#{file.blob.filename}</a>"
      end
    end
    column :project
    column :facility do |task|
      raw "<a href='#{edit_admin_facility_path(task.facility)}'>#{task.facility.facility_name}</a>" if task.facility.present?
    end
    actions
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys

    f.inputs 'Basic Details' do
      f.input :text, label: 'Name'
      f.input :project_id, label: 'Project', as: :select, collection: Project.all.map{|p| [p.name, p.id]}
      f.input :facility_id, label: 'Facility', as: :select, collection: Facility.all.map{|f| [f.facility_name, f.id]}
      f.input :task_type
      f.input :start_date, as: :datepicker
      f.input :due_date, as: :datepicker
      f.input :progress
      div id: 'progress_slider-tab'
      f.input :task_files, as: :file, input_html: { multiple: true }
    end
    f.actions
  end

  filter :text, label: 'Name'
  filter :task_type
  filter :start_date
  filter :due_date
  filter :facility_project_project_id, as: :select, collection: Project.pluck(:name, :id), label: 'Project'
  filter :facility_project_facility_facility_name, as: :string, label: 'Facility'
  filter :progress

end
