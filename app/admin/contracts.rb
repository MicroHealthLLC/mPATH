# ActiveAdmin.register Contract do
#   menu priority: 11
#   actions :all, except: [:show]

#   breadcrumb do
#     links = [link_to('Admin', admin_root_path), link_to('Contracts', admin_contracts_path)]
#     if %(show edit).include?(params['action'])
#       links << link_to(contract.name, edit_admin_contract_path)
#     end
#     links
#   end

#   permit_params do
#     permitted = [
#       :id,
#       :contract_type_id,
#       :project_code,
#       :nickname,
#       :contract_status_id,
#       :contract_customer_id,
#       :contract_vehicle_id,
#       :contract_vehicle_number_id,
#       :contract_number_id,
#       :contract_classification_id,
#       :subcontract_number_id,
#       :contract_prime_id,
#       :start_date,
#       :end_date,
#       :contract_current_pop_id,
#       :current_pop_start_time,
#       :current_pop_end_time,
#       :days_remaining,
#       :total_contract_value,
#       :current_pop_value,
#       :current_pop_funded,
#       :total_contract_funded,
#       :user_id,
#       :created_at,
#       :updated_at,
#       :facility_group_id,
#       :project_id,
#       :name
#     ]
#   end

#   index do
#     div id: '__privileges', 'data-privilege': "#{current_user.admin_privilege}"
#     selectable_column if current_user.admin_write? || current_user.admin_delete?
#     column :name
#     column :contract_type, nil, sortable: 'contract_types.name' do |contract|
#       if current_user.admin_write?
#         link_to "#{contract.contract_type.name}", "#{edit_admin_contract_type_path(contract.contract_type)}" if contract.contract_type.present?
#       else
#         "<span>#{contract.contract_type&.name}</span>".html_safe
#       end
#     end
#     column :contract_status, nil, sortable: 'contract_statuses.name' do |contract|
#       if current_user.admin_write?
#         link_to "#{contract.contract_status.name}", "#{edit_admin_contract_status_path(contract.contract_status)}" if contract.contract_status.present?
#       else
#         "<span>#{contract.contract_status&.name}</span>".html_safe
#       end
#     end
#     column :contract_customer, nil, sortable: 'contract_customeres.name' do |contract|
#       if current_user.admin_write?
#         link_to "#{contract.contract_customer.name}", "#{edit_admin_contract_customer_path(contract.contract_customer)}" if contract.contract_customer.present?
#       else
#         "<span>#{contract.contract_customer&.name}</span>".html_safe
#       end
#     end
#     column :contract_vehicle, nil, sortable: 'contract_vehicles.name' do |contract|
#       if current_user.admin_write?
#         link_to "#{contract.contract_vehicle.name}", "#{edit_admin_contract_vehicle_path(contract.contract_vehicle)}" if contract.contract_vehicle.present?
#       else
#         "<span>#{contract.contract_vehicle&.name}</span>".html_safe
#       end
#     end
#     column :contract_vehicle_number, nil, sortable: 'contract_vehicle_numbers.name' do |contract|
#       if current_user.admin_write?
#         link_to "#{contract.contract_vehicle_number.name}", "#{edit_admin_contract_vehicle_number_path(contract.contract_vehicle_number)}" if contract.contract_vehicle_number.present?
#       else
#         "<span>#{contract.contract_vehicle_number&.name}</span>".html_safe
#       end
#     end
#     column :contract_number, nil, sortable: 'contract_numbers.name' do |contract|
#       if current_user.admin_write?
#         link_to "#{contract.contract_number.name}", "#{edit_admin_contract_number_path(contract.contract_number)}" if contract.contract_number.present?
#       else
#         "<span>#{contract.contract_number&.name}</span>".html_safe
#       end
#     end
#     column :subcontract_number, nil, sortable: 'subcontract_numbers.name' do |contract|
#       if current_user.admin_write?
#         link_to "#{contract.subcontract_number.name}", "#{edit_admin_subcontract_number_path(contract.subcontract_number)}" if contract.subcontract_number.present?
#       else
#         "<span>#{contract.subcontract_number&.name}</span>".html_safe
#       end
#     end
#     column :contract_prime, nil, sortable: 'contract_primes.name' do |contract|
#       if current_user.admin_write?
#         link_to "#{contract.contract_prime.name}", "#{edit_admin_contract_prime_path(contract.contract_prime)}" if contract.contract_prime.present?
#       else
#         "<span>#{contract.contract_prime&.name}</span>".html_safe
#       end
#     end
#     column :contract_current_pop, nil, sortable: 'contract_current_pops.name' do |contract|
#       if current_user.admin_write?
#         link_to "#{contract.contract_current_pop.name}", "#{edit_admin_contract_current_pop_path(contract.contract_current_pop)}" if contract.contract_current_pop.present?
#       else
#         "<span>#{contract.contract_current_pop&.name}</span>".html_safe
#       end
#     end
#     column :contract_classification, nil, sortable: 'contract_classifications.name' do |contract|
#       if current_user.admin_write?
#         link_to "#{contract.contract_classification.name}", "#{edit_admin_contract_classification_path(contract.contract_classification)}" if contract.contract_classification.present?
#       else
#         "<span>#{contract.contract_classification&.name}</span>".html_safe
#       end
#     end


#     actions defaults: false do |contract|
#       # item "Edit", edit_admin_contract_path(contract), title: 'Edit', class: "member_link edit_link" if current_user.admin_write?
#       # item "Delete", admin_contract_path(contract), title: 'Delete', class: "member_link delete_link", 'data-confirm': 'Are you sure you want to delete this?', method: 'delete' if current_user.admin_delete?
#     end
#   end

#   # form do |f|
#   #   f.semantic_errors *f.object.errors.keys
#   #   div id: 'direct-upload-url', "data-direct-upload-url": "#{rails_direct_uploads_url}"

#   #   tabs do
#   #     tab 'Contract Info' do
#   #       f.inputs 'Basic Details' do
#   #         f.input :id, input_html: { value: f.object.id }, as: :hidden
#   #         f.input :name
#   #         f.input :contract_type, include_blank: true
#   #         f.input :contract_status, include_blank: true
#   #         f.input :contract_customer, include_blank: true
#   #         f.input :contract_vehicle, include_blank: true
#   #         f.input :contract_vehicle_number, include_blank: true
#   #         f.input :contract_number, include_blank: true
#   #         f.input :subcontract_number, include_blank: true
#   #         f.input :contract_prime, include_blank: true
#   #         f.input :contract_current_pop, include_blank: true
#   #         f.input :contract_classification, include_blank: true
#   #         f.input :facility_group, include_blank: true
#   #         f.input :project, include_blank: true
#   #       end
#   #     end
#   #   end
#   #   f.actions
#   # end

#   # batch_action :destroy, if: proc {current_user.admin_delete?}, confirm: "Are you sure you want to delete these Issues?" do |ids|
#   #   deleted = Issue.where(id: ids).destroy_all
#   #   redirect_to collection_path, notice: "Successfully deleted #{deleted.count} Issues"
#   # end

#   # batch_action :add_checklist_to_issues, if: proc {current_user.admin_write?}, form: -> {{
#   #   "Title": :text,
#   #   "Checked": :checkbox,
#   #   "User Assigned": User.active.map{|u| [u.full_name, u.id]},
#   #   "Due Date": :datepicker
#   # }} do |ids, inputs|
#   #   Issue.where(id: ids).each do |issue|
#   #     issue.checklists.create(text: inputs['Title'], checked: inputs['Checked'], user_id: inputs['User Assigned'], due_date: inputs['Due Date'])
#   #   end
#   #   redirect_to collection_path, notice: "Successfully created Issue checklists"
#   # end

#   # csv do
#   #   column(:title)
#   #   column(:task_type) { |issue| issue.task_type&.name }
#   #   column(:issue_type) { |issue| issue.issue_type&.name }
#   #   column(:issue_severity) { |issue| issue.issue_severity&.name }
#   #   column(:issue_stage) { |issue| issue.issue_stage&.name }
#   #   column(:progress)
#   #   column(:start_date) { |issue| issue.start_date&.strftime('%d/%b/%Y') }
#   #   column(:due_date) { |issue| issue.due_date&.strftime('%d/%b/%Y') }
#   #   column(:issue_files) { |issue| issue.issue_files&.map { |f| f.blob.filename.instance_variable_get('@filename') } }
#   #   column('Program') { |issue| issue.project&.name }
#   #   column('Project') { |issue| issue.facility&.facility_name }
#   #   column(:users) { |issue| issue.users&.map(&:full_name) }
#   # end

#   # filter :title
#   # filter :task_type
#   # filter :issue_type
#   # filter :issue_severity
#   # filter :issue_stage
#   # filter :progress
#   # filter :start_date
#   # filter :due_date, label: 'Estimated Completion Date'
#   # filter :facility_project_project_id, as: :select, collection: -> { Project.pluck(:name, :id) },
#   #                                      label: 'Program', input_html: { multiple: true }
#   # filter :facility_project_facility_id, as: :select, collection: -> { Facility.pluck(:facility_name, :id) },
#   #                                       label: 'Project', input_html: { multiple: true }
#   # filter :users_email, as: :string, label: "Email", input_html: {id: '__users_filter_emails'}
#   # filter :users, as: :select, collection: -> {User.where.not(last_name: ['', nil]).or(User.where.not(first_name: [nil, ''])).map{|u| ["#{u.first_name} #{u.last_name}", u.id]}}, label: 'Assigned To', input_html: {multiple: true}
#   # filter :checklists_user_id, as: :select, collection: -> {User.where.not(last_name: ['', nil]).or(User.where.not(first_name: [nil, ''])).map{|u| ["#{u.first_name} #{u.last_name}", u.id]}}, label: 'Checklist Item assigned to', input_html: {multiple: true}
#   # filter :id, as: :select, collection: -> {[current_user.admin_privilege]}, input_html: {id: '__privileges_id'}, include_blank: false

#   controller do
#     before_action :check_readability, only: [:index, :show]
#     before_action :check_writeability, only: [:new, :edit, :update, :create]

#     def check_readability
#       redirect_to '/not_found' and return unless current_user.admin_read?
#     end

#     def check_writeability
#       redirect_to '/not_found' and return unless current_user.admin_write?
#     end

#     def create
#       build_resource
#       handle_links
#       handle_files
#       super
#     end

#     def update
#       handle_links
#       handle_files
#       super
#     end

#     # def handle_files
#     #   resource.manipulate_files(params) if resource.present?
#     #   params[:issue].delete(:issue_files)
#     # end

#     # def handle_links
#     #   resource.manipulate_links(params) if resource.present?
#     #   params[:issue].delete(:file_links)
#     # end

#     def destroy
#       redirect_to '/not_found' and return unless current_user.admin_delete?
#       super
#     rescue ActiveRecord::StatementInvalid
#       flash[:error] = "Not able to delete this! Violates foreign key constraint."
#       redirect_back fallback_location: root_path
#     end

#     def scoped_collection
#       super.includes(:contract_type)
#     end
#   end

# end
