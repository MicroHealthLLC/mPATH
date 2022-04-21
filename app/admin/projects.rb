ActiveAdmin.register Project do
  menu priority: 3, label: 'Programs'
  actions :all, except: [:show]

  permit_params do
    permitted = [
      :name,
      :description,
      :project_type_id,
      :status,
      admin_program_admins: [],
      user_ids: [],
      facility_ids: [],
      status_ids: [],
      task_type_ids: [],
      issue_type_ids: [],
      issue_severity_ids: [],
      task_stage_ids: [],
      issue_stage_ids: [],
      risk_stage_ids: [],
      lesson_stage_ids: [],
      comments_attributes: [
        :id,
        :namespace,
        :author_id,
        :author_type,
        :body,
        :_destroy
      ]
    ]
    permitted
  end

  breadcrumb do
    links = [link_to('Admin', admin_root_path), link_to('Programs', admin_projects_path)]
    if %(show edit).include?(params['action'])
      links << link_to(project.name, edit_admin_project_path)
    end
    links
  end

  index title: 'Programs' do
    div id: '__privileges', 'data-privilege': "#{current_user.admin_privilege}"
    selectable_column if current_user.admin_write? || current_user.admin_delete?
    column :name
    column :description, sortable: false
    column "Program Type", :project_type, sortable: 'project_types.name' do |project|
      if current_user.admin_write?
        link_to "#{project.project_type.name}", "#{edit_admin_project_type_path(project.project_type)}" if project.project_type.present?
      else
        "<span>#{project.project_type&.name}</span>".html_safe
      end
    end
    column "Program Admins", :get_program_admins do |project|
      if current_user.admin_write?
        project.get_program_admins
      else
        "<span>#{project.get_program_admins.map(&:full_name).join(', ')}</span>".html_safe
      end
    end
    tag_column "State", :status
    actions defaults: false do |project|
      item "Edit", edit_admin_project_path(project), title: 'Edit', class: "member_link edit_link" if current_user.admin_write?
      item "Delete", admin_project_path(project), title: 'Delete', class: "member_link delete_link", 'data-confirm': 'Are you sure you want to delete this?', method: 'delete' if current_user.admin_delete?
    end
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys

    tabs do
      tab 'Basic' do
        f.inputs 'Basic Details' do
          f.input :name
          f.input :project_type, include_blank: false, include_hidden: false, label: "Program Type"
          f.input :status, include_blank: false, include_hidden: false, label: "State"
          f.input :description
          f.input :admin_program_admins, label: 'Program Admins*', as: :select, collection: options_for_select(  User.client.active.map{|u| [u.email, u.id]}, f.object.get_program_admin_ids ), multiple: true, input_html: {class: "select2", "data-close-on-select" => false }
        end
      end

      tab 'Advanced' do
        f.inputs 'Program Details' do
          # input :users, label: 'Users in Program', as: :select, collection: options_for_select(  User.client.active.map{|u| [u.email, u.id]}, f.object.user_ids ), multiple: true, input_html: {class: "select2", "data-close-on-select" => false }
          # input :facilities, label: 'Projects in Program', as: :select, collection: options_for_select(Facility.active.map{|u| [u.facility_name, u.id]}, f.object.facility_ids) , multiple: true, input_html: {class: "select2", "data-close-on-select" => false }
          input :statuses, label: 'Statuses in Program', as: :select, collection:  options_for_select( Status.all.map{|u| [u.name, u.id]}, f.object.status_ids ), multiple: true, input_html: {class: "select2", "data-close-on-select" => false }
          input :task_stages, label: 'Task Stages in Program', as: :select, collection: options_for_select( TaskStage.all.map{|u| [u.name, u.id]}, f.object.task_stage_ids), multiple: true, input_html: {class: "select2", "data-close-on-select" => false }
          input :task_types, label: 'Process Areas in Program', as: :select, collection: options_for_select( TaskType.all.map{|u| [u.name, u.id]}, f.object.task_type_ids), multiple: true, input_html: {class: "select2", "data-close-on-select" => false }
          input :issue_types, label: 'Issue Types in Program', as: :select, collection: options_for_select( IssueType.all.map{|u| [u.name, u.id]}, f.object.issue_type_ids) , multiple: true, input_html: {class: "select2", "data-close-on-select" => false }
          input :issue_severities, label: 'Issue Severities in Program', as: :select, collection: options_for_select( IssueSeverity.all.map{|u| [u.name, u.id]}, f.object.issue_severity_ids ), multiple: true, input_html: {class: "select2", "data-close-on-select" => false }
          input :issue_stages, label: 'Issue Stages in Program', as: :select, collection: options_for_select( IssueStage.all.map{|u| [u.name, u.id]}, f.object.issue_stage_ids), multiple: true, input_html: {class: "select2", "data-close-on-select" => false }
          input :risk_stages, label: 'Risk Stages in Program', as: :select, collection: options_for_select( RiskStage.all.map{|u| [u.name, u.id]}, f.object.risk_stage_ids), multiple: true, input_html: {class: "select2", "data-close-on-select" => false }
          input :lesson_stages, label: 'Lesson Stages in Program', as: :select, collection: options_for_select( LessonStage.all.map{|u| [u.name, u.id]}, f.object.lesson_stage_ids), multiple: true, input_html: {class: "select2", "data-close-on-select" => false }

        end
      end

      tab 'Comments' do
        f.inputs 'Comments' do
          f.has_many :comments, heading: false do |c|
            c.input :author, as: :select, label: "Comments by", collection: User.where(id: c.object.author_id).map {|u| [u.full_name, u.id]} if c.object.id?
            c.input :created_at, as: :string, label: 'Created at', input_html: {value: pretty_format(c.object.created_at)} if c.object.id?
            c.input :updated_at, as: :string, label: 'Last Updated at', input_html: {value: pretty_format(c.object.updated_at)} if (c.object.id? and c.object.updated_at > c.object.created_at)
            c.input :body, label: "Comment body", input_html: {readonly: (c.object.id? and c.object.author_id != current_user.id), disabled: (c.object.id? and c.object.author_id != current_user.id), rows: 7}
            c.input :_destroy, as: :boolean, label: "Delete" if (c.object.id? and c.object.author_id == current_user.id)
          end
        end
      end
    end
    f.actions
  end

  filter :name
  filter :project_type, label: "Program Type"
  filter :status, as: :select, collection: Project.statuses, label: "State"
  filter :program_admins, as: :string, label: "Program Admins"
  filter :id, as: :select, collection: -> {[current_user.admin_privilege]}, input_html: {id: '__privileges_id'}, include_blank: false

  batch_action :assign_state, if: proc {current_user.admin_write?}, form: {
    "State": Project.statuses&.to_a
  } do |ids, inputs|
    Project.where(id: ids).update_all(status: inputs['State'].to_i)
    redirect_to collection_path, notice: 'State is updated'
  end

  batch_action :destroy, if: proc {current_user.admin_delete?}, confirm: "Are you sure you want to delete these Programs?" do |ids|
    deleted = Project.where(id: ids).destroy_all
    redirect_to collection_path, notice: "Successfully deleted #{deleted.count} Programs"
  end

  controller do
    before_action :check_readability, only: [:index, :show]
    before_action :check_order, only: [:index]
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
    rescue ActiveRecord::StatementInvalid
      flash[:error] = "Not able to delete this! Violates foreign key constraint."
      redirect_back fallback_location: root_path
    end

    def create
      normalize_comment_params
      # super
      p_params = permitted_params[:project]
      user_ids = p_params.delete("user_ids")
      # project_admins = p_params.delete("admin_program_admins")
      project = Project.new(p_params)
      if project.save
        project.user_ids = project.user_ids + user_ids if user_ids.present?
        users = User.where(id: project.admin_program_admins)
        project.user_ids = (project.user_ids + users.pluck(:id)).compact.uniq if users.any?
        role_users = []
        role_id = Role.program_admin_role.id
        users.each do |user|
          role_users << RoleUser.new(user_id: user.id, role_id: role_id, project_id: project.id)
        end
        RoleUser.import(role_users)
        
        redirect_to admin_projects_path , notice: "Program created Successfully"
      else
        # render :new
        super
      end

    end

    def update(options={}, &block)
      normalize_comment_params
      if params[:project][:user_ids]
        removed_user_ids = resource.user_ids - params[:project][:user_ids].map(&:to_i)
        User.where(id: removed_user_ids).each do |user|
          user.remove_all_privileges(resource.id)
        end if removed_user_ids.any?
      end
      p_params = permitted_params[:project]

      role_id = Role.program_admin_role.id

      p_project_admin_ids = p_params.delete("admin_program_admins").reject { |c| c.empty? }.map(&:to_i)
      existing_program_admin_ids = resource.get_program_admin_ids

      all_project_admin_ids = (p_project_admin_ids + existing_program_admin_ids).uniq
      new_project_admin_ids = (all_project_admin_ids - existing_program_admin_ids).uniq
      remove_project_admin_ids = (all_project_admin_ids - p_project_admin_ids).uniq

      role_users = []
      users = User.where(id: new_project_admin_ids)
      users.each do |user|
        role_users << RoleUser.new(user_id: user.id, role_id: role_id, project_id: resource.id)
      end
      RoleUser.import(role_users)
      
      RoleUser.where(user_id: remove_project_admin_ids, role_id: role_id, project_id: resource.id).destroy_all

      params[:project][:user_ids] = ( params[:project][:user_ids] - remove_project_admin_ids.map(&:to_s)) if remove_project_admin_ids.any?
      params[:project][:user_ids] = ( params[:project][:user_ids] + new_project_admin_ids.map(&:to_s)) if new_project_admin_ids.any?

      resource.delete_nested_facilities(params[:project][:facility_ids]) if params[:project][:facility_ids].present?
      super do |success, failure|
        block.call(success, failure) if block
        failure.html {render :edit}
      end
    end

    def check_order
      order = Project.sort_order?
      redirect_to admin_projects_path(order: order) and return unless params[:order] == order
    end

    def normalize_comment_params
      i = 0
      while params[:project][:comments_attributes][i.to_s].present?
        params[:project][:comments_attributes][i.to_s]['namespace'] = 'admin'
        params[:project][:comments_attributes][i.to_s]['author_id'] = current_user.id
        params[:project][:comments_attributes][i.to_s]['author_type'] = 'User'
        i = i+1
      end  if params[:project][:comments_attributes].present?
    end

    def index
      super do |format|
        format.json {send_data collection.to_json, type: :json, disposition: "attachment"}
      end
    end

    def scoped_collection
      super.includes(:project_type)
    end
  end

end
