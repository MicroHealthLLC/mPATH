# You can setup your Rails state here
# MyModel.create name: 'something'


 roles = [
   {
     role_type: "update-project", 
     type_of: 'project',
     role_privileges: RolePrivilege::PROJECT_PRIVILEGS_ROLE_TYPES.map{ |role_privilege| {name: role_privilege, privilege: "RWD",role_type: role_privilege} }
   },
   {
     role_type: "read-project", 
     type_of: 'project',
     role_privileges: RolePrivilege::PROJECT_PRIVILEGS_ROLE_TYPES.map{ |role_privilege| {name: role_privilege, privilege: "R",role_type: role_privilege} }
   },
   {
     role_type: "contribute-project", 
     type_of: 'project',
     role_privileges: RolePrivilege::PROJECT_PRIVILEGS_ROLE_TYPES.map{ |role_privilege| {name: role_privilege, privilege: "RW",role_type: role_privilege} }
   },
 
   {
     role_type: "update-contract", 
     type_of: 'contract',
     role_privileges: RolePrivilege::CONTRACT_PRIVILEGS_ROLE_TYPES.map{ |role_privilege| {name: role_privilege, privilege: "RWD",role_type: role_privilege} }
   },
   {
     role_type: "read-contract", 
     type_of: 'contract',
     role_privileges: RolePrivilege::CONTRACT_PRIVILEGS_ROLE_TYPES.map{ |role_privilege| {name: role_privilege, privilege: "R",role_type: role_privilege} }
   },
   {
     role_type: "contribute-contract", 
     type_of: 'contract',
     role_privileges: RolePrivilege::CONTRACT_PRIVILEGS_ROLE_TYPES.map{ |role_privilege| {name: role_privilege, privilege: "RW",role_type: role_privilege} }
   },
 
   {
     role_type: "program-admin",
     type_of: 'admin',
     role_privileges: RolePrivilege::PROGRAM_SETTINGS_ROLE_TYPES.map{ |role_privilege| {name: role_privilege, privilege: "RWD",role_type: role_privilege} }
   },
   {
     role_type: "program-admin-not-users",
     type_of: 'admin',
     role_privileges: (RolePrivilege::PROGRAM_SETTINGS_ROLE_TYPES - ["program_setting_users_roles"]).map{ |role_privilege| {name: role_privilege, privilege: "RWD",role_type: role_privilege} }
   },
   {
     role_type: "program-admin-not-contract",
     type_of: 'admin',
     role_privileges: ( RolePrivilege::PROGRAM_SETTINGS_ROLE_TYPES - ["program_setting_contracts"]).map{ |role_privilege| {name: role_privilege, privilege: "RWD",role_type: role_privilege} }
   },
 ]
 
 roles.each do |role_hash|
   Role.find_or_create_by(name: role_hash[:role_type]) do |s|
     s.name = role_hash[:role_type]
     s.is_portfolio = true
     s.is_default = true
     s.type_of = role_hash[:type_of]
     s.role_privileges_attributes = role_hash[:role_privileges]
   end
 end
 
 program_admin_role = Role.program_admin_user_role
 project_update_role = Role.where(name: "update-project").first
 
 organization = Organization.find_or_create_by(title: 'Test Organization')
 admin = User.find_or_initialize_by(email: 'admin@test.com')
 admin.assign_attributes(
   password: 'T3$tAdmin',
   password_confirmation: 'T3$tAdmin',
   title: 'Manager',
   first_name: 'Test1',
   role: "superadmin",
   last_name: 'Admin',
   phone_number: '+447400123440',
   address: '38 Wiltshire Rd, Leicester LE4 0JT, UK',
   organization_id: organization.id
 )
 admin.privilege = Privilege.new(
   overview: "RWD",
   tasks: "RWD",
   notes: "RWD",
   issues: "RWD",
   admin: "RWD",
   map_view: "RWD",
   gantt_view: "RWD",
   watch_view: "RWD",
   documents: "RWD",
   members: "RWD",
   facility_manager_view: "R",
   sheets_view: "R",
   kanban_view: "R",
   risks: "R",
   calendar_view: "R"
 )
 admin.save(validate: false)
 
 client = User.find_or_initialize_by(email: 'client@test.com')
 client.assign_attributes(
   password: 'T3$tClient',
   password_confirmation: 'T3$tClient',
   title: 'Mr.',
   first_name: 'Test2',
   last_name: 'Client',
   role: 'client',
   phone_number: '+447400123450',
   address: '56 Second Ave, Pensnett Trading Estate, Kingswinford DY6 7XN, UK',
   organization_id: organization.id
 )
 client.privilege = Privilege.new(
   overview: "R",
   tasks: "R",
   notes: "R",
   issues: "R",
   admin: "R",
   map_view: "R",
   gantt_view: "R",
   watch_view: "R",
   documents: "R",
   members: "R",
   facility_manager_view: "R",
   sheets_view: "R",
   kanban_view: "R",
   risks: "R",
   calendar_view: "R"
 )
 client.save(validate: false)
 
 Setting.first_or_create(google_map_key: ENV['GOOGLE_MAP_KEY'])
 
 project_type = ProjectType.find_or_create_by(name: 'Test Project Type')
 project = Project.new(
   name: 'Test Project',
   description: 'Test project description',
   project_type_id: project_type.id,
   admin_program_admins: [admin.id.to_s]
 )
 project.save
 
 RoleUser.new(project_id: project.id, user_id: admin.id, role_id: program_admin_role.id ).save
 
 ProjectUser.find_or_create_by(project_id: project.id, user_id: admin.id)
 ProjectUser.find_or_create_by(project_id: project.id, user_id: client.id)
 
 active_status = Status.find_or_create_by(name: 'Active', color: '#0b8e1a')
 inactive_status = Status.find_or_create_by(name: 'InActive', color: '#c90d0d')
 
 ProjectStatus.find_or_create_by(project_id: project.id, status_id: active_status.id)
 ProjectStatus.find_or_create_by(project_id: project.id, status_id: inactive_status.id)
 
 task_type = TaskType.find_or_create_by(name: 'Test Task Type(milestone)')
 task_stage = TaskStage.find_or_create_by(name: 'Test Task Stage', percentage: 40)
 new_task_stage = TaskStage.find_or_create_by(name: 'New Task Stage', percentage: 60)
 
 ProjectTaskStage.find_or_create_by(project_id: project.id, task_stage_id: task_stage.id)
 ProjectTaskStage.find_or_create_by(project_id: project.id, task_stage_id: new_task_stage.id)
 
 project_task_type = ProjectTaskType.create(project_id: project.id, task_type_id: task_type.id)

 facility_group_1 = FacilityGroup.find_or_create_by(
   name: 'Test Facility Group 1',
   code: 'TFG1',
   status: 'active',
   is_portfolio: true
 )
 facility_1 = Facility.find_or_create_by(
   facility_name: 'Test Facility 1',
   address: '2-20 Western Rd, Park Royal, London NW10 7LW, UK',
   point_of_contact: 'Test points',
   phone_number: '+447400123451',
   email: 'facility1@test.com',
   lat: '51.5285728',
   lng: '-0.2696692999999999' ,
   status: 'active',
   country_code: 'GB',
   creator_id: admin.id,
   facility_group_id: facility_group_1.id
 )
 
 facility_project_1 = FacilityProject.find_or_create_by(
   project_id: project.id,
   facility_id: facility_1.id,
   status_id: active_status.id,
   due_date: Date.today + 10.days,
   facility_group_id: facility_1.facility_group.id
 )
 
 RoleUser.new(project_id: project.id, facility_project_id: facility_project_1.id, user_id: client.id, role_id: project_update_role.id ).save
 
 test_task_1 = Task.find_or_create_by(
   text: 'Test Task 1',
   description: 'Test task 1 description',
   start_date: Date.today,
   due_date: Date.today + 5.days,
   task_type_id: task_type.id,
   task_stage_id: task_stage.id,
   facility_project_id: facility_project_1.id,
   watched: true,
   progress: 10
 )
 
 TaskUser.find_or_create_by(task_id: test_task_1.id, user_id: admin.id)
 
 new_task_1 = Task.find_or_create_by(
   text: 'New Task 1',
   description: 'New task 1 description',
   start_date: Date.today + 1.day,
   due_date: Date.today + 6.days,
   task_type_id: task_type.id,
   task_stage_id: new_task_stage.id,
   facility_project_id: facility_project_1.id,
   watched: false,
   progress: 70
 )
 
 TaskUser.find_or_create_by(task_id: new_task_1.id, user_id: client.id)

 effort_1 = Effort.find_or_create_by({
  date_of_week: DateTime.now,
  hours: 10,
  user_id: client.id,
  resource_id: test_task_1.id,
  resource_type: 'Task',
  facility_project_id: facility_project_1.id,
  projected: false
 })