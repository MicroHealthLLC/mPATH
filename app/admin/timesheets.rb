ActiveAdmin.register Timesheet do
  menu priority: 5
  actions :all, except: [:show]

  breadcrumb do
    links = [link_to('Admin', admin_root_path), link_to('Timesheets', admin_timesheets_path)]
    if %(show edit).include?(params['action'])
      links << link_to(timesheet.resource.text, edit_admin_timesheet_path)
    end
    links
  end

  permit_params do
    permitted = [
      :hours,
      :date_of_week,
      :user_id,
      :resource_id,
      :resource_type,
      :facility_project_id
    ]
  end

  form do |f|
    f.semantic_errors *f.object.errors
    f.inputs  do
      f.input :id, input_html: { value: f.object.id }, as: :hidden
      f.input :hours
      f.input :date_of_week, as: :datepicker
      facility_project_options = []
            
      Project.includes([{facility_projects: :facility }]).in_batches(of: 1000) do |projects|
        projects.each do |project|
          facility_project_options << [project.name, project.id, {disabled: true}]
          project.facility_projects.each do |fp|
            facility_project_options << ["&nbsp;&nbsp;&nbsp;#{fp.facility.facility_name}".html_safe, fp.id]
          end
        end
      end

      f.input :facility_project, label: 'Project', as: :select, collection: facility_project_options, input_html: {class: "select2"}

      f.input :user, label: 'User', as: :select, collection: User.active.map{|u| [u.full_name, u.id]},  input_html: {class: "select2"}

      task_options = []
      Task.in_batches do |tasks|
        tasks.each do |task|
          task_options << [task.text, task.id]
        end
      end
      f.input :resource, label: 'Task', as: :select, collection: task_options,  input_html: {class: "select2"}
    end

    f.actions
  end

end