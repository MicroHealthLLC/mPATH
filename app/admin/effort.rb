ActiveAdmin.register Effort do
  menu priority: 5
  actions :all, except: [:show]

  breadcrumb do
    links = [link_to('Admin', admin_root_path), link_to('Efforts', admin_efforts_path)]
    if %(show edit).include?(params['action'])
      links << link_to(effort.resource.text, edit_admin_effort_path)
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

  index do
    selectable_column if current_user.admin_write? || current_user.admin_delete?

    column "Date of Week", :date_of_week
    column "Hours", :hours
    column "User", :users do |effort|
      if current_user.admin_write?
        effort.user
      else
        "<span>#{effort.user&.full_name}</span>".html_safe
      end
    end
    column "Resource", :resource, nil, sortable: 'projects.name' do |effort|
      if current_user.admin_write?
        link_to "#{effort.resource_type}##{effort.resource_id}", "#{edit_admin_task_path(effort.resource)}" if effort.resource.present?
      else
        "<span>#{effort.resource&.text}</span>".html_safe
      end
    end

    column "Project", :facility, nil, sortable: 'facility.facility_name' do |effort|
      if current_user.admin_write?
        link_to "#{effort.facility.facility_name}", "#{admin_facility_path(effort.facility)}" if effort.facility.present?
      else
        "<span>#{effort.facility&.facility_name}</span>".html_safe
      end
    end

    actions defaults: false do |effort|
      item "Edit", edit_admin_effort_path(effort), title: 'Edit', class: "member_link edit_link" if current_user.admin_write?
      item "Delete", admin_effort_path(effort), title: 'Delete', class: "member_link delete_link", 'data-confirm': 'Are you sure you want to delete this?', method: 'delete' if current_user.admin_delete?
    end
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
  filter :facility_project_facility_id, as: :select, collection: -> { Facility.pluck(:facility_name, :id) }, label: 'Project', input_html: { multiple: true }

  filter :user, as: :select, collection: -> {User.where.not(last_name: ['', nil]).or(User.where.not(first_name: [nil, ''])).map{|u| ["#{u.first_name} #{u.last_name}", u.id]}}, label: 'User'

  filter :date_of_week
  filter :hours
  
end