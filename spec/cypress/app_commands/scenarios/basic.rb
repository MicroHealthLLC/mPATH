# You can setup your Rails state here
# MyModel.create name: 'something'

# Adding sort record used for Admin panel
sorts = [{"relation"=>"checklists", "column"=>"id", "order"=>"asc"},
 {"relation"=>"facilities", "column"=>"id", "order"=>"asc"},
 {"relation"=>"facility_groups", "column"=>"name", "order"=>"asc"},
 {"relation"=>"facility_projects", "column"=>"id", "order"=>"asc"},
 {"relation"=>"issue_severities", "column"=>"name", "order"=>"desc"},
 {"relation"=>"issue_types", "column"=>"name", "order"=>"desc"},
 {"relation"=>"issue_users", "column"=>"id", "order"=>"asc"},
 {"relation"=>"issues", "column"=>"id", "order"=>"asc"},
 {"relation"=>"notes", "column"=>"id", "order"=>"asc"},
 {"relation"=>"privileges", "column"=>"id", "order"=>"asc"},
 {"relation"=>"project_types", "column"=>"id", "order"=>"asc"},
 {"relation"=>"project_users", "column"=>"id", "order"=>"asc"},
 {"relation"=>"projects", "column"=>"name", "order"=>"desc"},
 {"relation"=>"region_states", "column"=>"id", "order"=>"asc"},
 {"relation"=>"statuses", "column"=>"name", "order"=>"desc"},
 {"relation"=>"task_types", "column"=>"name", "order"=>"asc"},
 {"relation"=>"tasks", "column"=>"id", "order"=>"asc"},
 {"relation"=>"users", "column"=>"id", "order"=>"asc"},
 {"relation"=>"task_stages", "column"=>"name", "order"=>"asc"},
 {"relation"=>"issue_stages", "column"=>"percentage", "order"=>"desc"},
 {"relation"=>"risk_milestones", "column"=>"id", "order"=>"asc"},
 {"relation"=>"risk_stages", "column"=>"percentage", "order"=>"desc"}]

sorts.each do |sort|
  Sort.find_or_create_by(relation: sort["relation"]) do |s|
    s.attributes = sort
  end
end

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

RoleUser.new(project_id: project.id, user_id: admin.id, role_id: Role.program_admin_user_role.id ).save

ProjectUser.find_or_create_by(project_id: project.id, user_id: admin.id)
ProjectUser.find_or_create_by(project_id: project.id, user_id: client.id)

active_status = Status.find_or_create_by(name: 'Active', color: '#0b8e1a')
inactive_status = Status.find_or_create_by(name: 'InActive', color: '#c90d0d')

ProjectStatus.find_or_create_by(project_id: project.id, status_id: active_status.id)
ProjectStatus.find_or_create_by(project_id: project.id, status_id: inactive_status.id)

task_type = TaskType.find_or_create_by(name: 'Test Task Type(milestone)')
task_stage = TaskStage.find_or_create_by(name: 'Test Task Stage', percentage: 40)
new_task_stage = TaskStage.find_or_create_by(name: 'New Task Stage', percentage: 60)
issue_stage = IssueStage.find_or_create_by(name: 'Test Issue Stage', percentage: 40)
new_issue_stage = IssueStage.find_or_create_by(name: 'New Issue Stage', percentage: 60)
risk_stage = RiskStage.find_or_create_by(name: 'Test Risk Stage', percentage: 40)
new_risk_stage = RiskStage.find_or_create_by(name: 'New Risk Stage', percentage: 60)
issue_type = IssueType.find_or_create_by(name: 'Test Issue Type')
issue_severity = IssueSeverity.find_or_create_by(name: 'Test Issue Severity')
lesson_stage = LessonStage.find_or_create_by(name: "Test Lesson Stage")
lesson_stage2 = LessonStage.find_or_create_by(name: "Test Lesson Stage 2")


ProjectTaskStage.find_or_create_by(project_id: project.id, task_stage_id: task_stage.id)
ProjectTaskStage.find_or_create_by(project_id: project.id, task_stage_id: new_task_stage.id)
ProjectIssueStage.find_or_create_by(project_id: project.id, issue_stage_id: issue_stage.id)
ProjectIssueStage.find_or_create_by(project_id: project.id, issue_stage_id: new_issue_stage.id)
ProjectRiskStage.find_or_create_by(project_id: project.id, risk_stage_id: risk_stage.id)
ProjectRiskStage.find_or_create_by(project_id: project.id, risk_stage_id: new_risk_stage.id)
ProjectLessonStage.find_or_create_by(project_id: project.id, lesson_stage_id: lesson_stage.id)
ProjectLessonStage.find_or_create_by(project_id: project.id, lesson_stage_id: lesson_stage2.id)


project_task_type = ProjectTaskType.create(project_id: project.id, task_type_id: task_type.id)
project_issue_severities = ProjectIssueSeverity.create(project_id: project.id, issue_severity_id: issue_severity.id)
project_issue_type = ProjectIssueType.create(project_id: project.id, issue_type_id: issue_type.id)

facility_group_1 = FacilityGroup.find_or_create_by(
  name: 'Test Facility Group 1',
  code: 'TFG1',
  status: 'active'
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



puts "Adding Contract types"
contract_types = [ "Prime Contract", "Non Prime contract", "Prime vehicles and ID IQs"]
contract_types.each do |name|
  ContractType.find_or_create_by(name: name) do |s|
    s.name = name
    s.user_id = admin.id
  end
end

puts "Adding Contract Statues"
contract_statues = ["8A",  "8(a)/ SDVOSB",  "SDVOSB",  "SB",  "8(a)",  "N/A"]
contract_statues.each do |name|
  ContractStatus.find_or_create_by(name: name) do |s|
    s.name = name
  end
end

puts "Adding Contract name customers"
contract_name_customers = ["VA",  "IPO",  "DHA",  "3M",  "DIA",  "SEC",  "Army",  "USCG",  "HHS/HRSA",  "ARNG",  "DHMS/DHA",  "HRSA",  "DOS",  "SBA",  "DOE"]
contract_name_customers.each do |name|
  ContractCustomer.find_or_create_by(name: name) do |s|
    s.name = name
    s.user_id = admin.id
  end
end

puts "Adding Contract vehicles"
contract_vehicles = ["VAEHRM","Connections II","GSA IT-70 SIN 132-51","T4NG","8(a) STARS2","GSA IT-70","GSA PSS","DIA ESITA 2","WITS 3","CIO-SP3 (SDVOSB)","GAS","GSA IT-70 SIN 132-56","VETS 2 GWAC ","TBA","N/A"]
contract_vehicles.each do |name|
  ContractVehicle.find_or_create_by(name: name) do |s|
    s.name = name
    s.user_id = admin.id
  end
end

puts "Adding Contract vehicle numbers"
contract_vehicle_numbers = ["0353-21-2545","19AQMM19D0147","36C10B18D5000","36C10B20N0015","36C10B20N0028","47QRAA-18-D-0098","GS00Q17GWD2387","47QTCH18D0041","GS11T08BJD6001","GS-35F-0142W","GS35F349CA","GS-35F-413BA","HHSN316201800023W","HHM402-17-A-0007","HT003821C0006","VA118-16-D-1006","N/A","TBD"]
contract_vehicle_numbers.each do |name|
  ContractVehicleNumber.find_or_create_by(name: name) do |s|
    s.name = name
  end
end

puts "Adding Contract number"
contract_numbers = ["0353-21-2545/7335105102P0012","19AQMM19D0147/19AQMM19F4405","19AQMM19D0147/19AQMM20F0955","19AQMM19D0147/19AQMM20F1904","19AQMM19D0147/19AQMM20F2118","36C10B18D5000","36C10B19N0008","36C19N0010","36C10B19N0016","36C10B19N0021","36C10B20N0015","36C10B20N0015EHRM","36C10B20N0030","36C10B20N0034","36C10B20N0035","36C10B20N0036","36C10B20N10060037","47QFSA20F0034","47FWA19F0046","47QTCH18D0041/47QFSA21F0005","50310219A0005/50310219F0145","50310219A0005/50310220F0086","50310219A0005/50310220F0119","75N98118D00023/70Z0G320FPMG00100","89303020CMA00052","GS00Q1700Q17GWD2387","GS11T08BJD6001","GS35F413BA/140D418F0001","GS35F413BA175R60220F80134","HHM402-17-A-0007/0008","HHSH250201800032B/75R60220F34006","HHSh25020180032b/75R60220F34007","HQMMMBBX6","HT001419C0023","HT003821C0006","Q-ACLD-19-SME-01","VA118-16-F-1006-0012","VA11817F10060016","W81XWH18F0361","W912DY-19-C-0018","W9133L-21-C-1000","TBA"]
contract_numbers.each do |name|
  ContractNumber.find_or_create_by(name: name) do |s|
    s.name = name
  end
end

puts "Adding sub Contract numbers"
subcontract_numbers = ["2016-004-T4NG-SC/POVAT4NG-016-006","2016-004-T4NG-SC/PO-T4NG-037-002","2017-006-T4NG-SC/POVAT4NG-012-003","2018-001-DIA-SC/DIA-008-002","2020-02","AstraFireJV2019-004/AFJV202151","GCMS41714","IIS-2015-SUB002/2021-ARNG-1003","MA-000789-2018/PO2TI0502-01","MASI1-19-S-LH-0225","N/A","S21012","SC-13-04","SC-13-04/PO2019-0075&PO2019-077/2020-0116","TO 53444-15","TO 52492-15","TO 53940-08","TO 55543-28","TO 56511-28","TO 57551-10","TO 57552-16","TO  57553-21","TO 57554-30","TO 57555-34","TO 57556-35","TO 57557-36","TO 57564-08","TO 57789-15"]
subcontract_numbers.each do |name|
  SubcontractNumber.find_or_create_by(name: name) do |s|
    s.name = name
  end
end

puts "Adding Contract primes"
contract_primes = ["3M","American Systems Cooperation","AstraFine JV LLC","Cerner Government Services, inc.","Diverse Systems Group, LLC","Favor TechConsulting, LLC","Innovative Information Solutions, LLC","ManTech Advance Systems International, inc.","MicroHealth, LLC","Planned Systems International inc.","Verizon Federal Services, inc."]
contract_primes.each do |name|
  ContractPrime.find_or_create_by(name: name) do |s|
    s.name = name
  end
end

puts "Adding Contract current pops"
contract_current_pops = ["Base Period","Base Period 2","Contract Yr 3","Option Period 1","Option Period 2","Option Period 3","Option Period 4","Option Year 1"]
contract_current_pops.each do |name|
  ContractCurrentPop.find_or_create_by(name: name) do |s|
    s.name = name
    s.user_id = admin.id
  end
end

puts "Adding Contract classification"
contract_classification = ["FFP","T&M","Labor Hour","FFP for support services/ T&M for travel","FFP/ T&M","FFP/ FFPU"]
contract_classification.each do |name|
  ContractClassification.find_or_create_by(name: name) do |s|
    s.name = name
  end
end

puts "Adding Contract categories"
contract_categories = ["Commercial", "Fedaral"]
contract_categories.each do |name|
  ContractCategory.find_or_create_by(name: name) do |s|
    s.name = name
  end
end

puts "Adding Contract client type"
contract_client_types = ["Government","Client"]
contract_client_types.each do |name|
  ContractClientType.find_or_create_by(name: name) do |s|
    s.name = name
  end
end





contract_1 = Contract.find_or_create_by(
  name: "Contarct 1",
  contract_type_id: ContractType.first.id,
  project_code: "Project Code 123",
  nickname: "Contract 1 Nickname",
  project_id: project.id,
  facility_group_id: facility_group_1.id,
  user_id: admin.id
)

contract_2 = Contract.find_or_create_by(
  name: "Contarct 2",
  contract_type_id: ContractType.first.id,
  project_code: "Project Code 123",
  nickname: "Contract 2 Nickname",
  project_id: project.id,
  facility_group_id: facility_group_1.id,
  user_id: client.id
)

facility_project_1 = FacilityProject.find_or_create_by(
  project_id: project.id,
  facility_id: facility_1.id,
  status_id: active_status.id,
  due_date: Date.today + 10.days,
  facility_group_id: facility_1.facility_group.id
)

Note.find_or_create_by(
  noteable_type: 'FacilityProject',
  noteable_id: facility_project_1.id,
  user_id: admin.id,
  body: 'Test Note 1'
)

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

test_issue_1 = Issue.find_or_create_by(
  title: 'Test Issue 1',
  description: 'Test issue 1 description',
  start_date: Date.today,
  due_date: Date.today + 5.days,
  issue_type_id: issue_type.id,
  task_type_id: task_type.id,
  issue_stage_id: issue_stage.id,
  issue_severity_id: issue_severity.id,
  facility_project_id: facility_project_1.id,
  watched: true,
  progress: 10
)

IssueUser.find_or_create_by(issue_id: test_issue_1.id, user_id: admin.id)

new_issue_1 = Issue.find_or_create_by(
  title: 'New Issue 1',
  description: 'New issue 1 description',
  start_date: Date.today + 1.day,
  due_date: Date.today + 6.days,
  issue_type_id: issue_type.id,
  task_type_id: task_type.id,
  issue_stage_id: new_issue_stage.id,
  issue_severity_id: issue_severity.id,
  facility_project_id: facility_project_1.id,
  watched: false,
  progress: 70
)

IssueUser.find_or_create_by(issue_id: new_issue_1.id, user_id: client.id)

test_risk_1 = Risk.find_or_create_by(
  text: 'Test Risk 1',
  risk_description: 'Test Risk 1 description',
  impact_description: 'Test Risk 1 impact description',
  start_date: Date.today,
  due_date: Date.today + 5.days,
  risk_approach_description: 'Test Risk 1 approach description',
  probability_description: 'Test Risk 1 probability description',
  user_id: admin.id,
  facility_project_id: facility_project_1.id,
  task_type_id: task_type.id,
  risk_stage_id: risk_stage.id,
  watched: true,
  progress: 10
)
test_risk_1.checklists.create(text: "Risk Checklist1", user_id: admin.id)
test_risk_1.checklists.create(text: "Risk Checklist1", user_id: client.id)

RiskUser.find_or_create_by(risk_id: test_risk_1.id, user_id: admin.id)

new_risk_1 = Risk.find_or_create_by(
  text: 'New Risk 1',
  risk_description: 'New Risk 1 description',
  impact_description: 'New Risk 1 impact description',
  start_date: Date.today + 1.day,
  due_date: Date.today + 5.days,
  risk_approach_description: 'New Risk 1 approach description',
  probability_description: 'New Risk 1 probability description',
  user_id: client.id,
  facility_project_id: facility_project_1.id,
  task_type_id: task_type.id,
  risk_stage_id: new_risk_stage.id,
  watched: false,
  progress: 70
)
new_risk_1.checklists.create(text: "Risk Checklist1", user_id: admin.id)
new_risk_1.checklists.create(text: "Risk Checklist1", user_id: client.id)

RiskUser.find_or_create_by(risk_id: new_risk_1.id, user_id: client.id)

new_lesson_1 = Lesson.find_or_create_by({
  "title" =>"Test Lesson 1",
  "description"=>"hello",
  "date"=>DateTime.now,
  "stage"=>nil,
  "task_type_id"=>task_type.id,
  "user_id"=>client.id,
  "important"=>false,
  "facility_project_id"=>facility_project_1.id,
  "reportable"=>false,
  "draft"=>false
})

facility_2 = Facility.find_or_create_by(
  facility_name: 'Test Facility 2',
  address: 'Abo Simbel Desert, Aswan Governorate 81514, Egypt',
  point_of_contact: 'Test points',
  phone_number: '+447400123452',
  email: 'facility2@test.com',
  lat: '23.6966498',
  lng: '32.7181375' ,
  status: 'active',
  country_code: 'GB',
  creator_id: admin.id,
  facility_group_id: facility_group_1.id
)

facility_project_2 = FacilityProject.find_or_create_by(
  project_id: project.id,
  facility_id: facility_2.id,
  status_id: inactive_status.id,
  due_date: Date.today + 10.days,
  facility_group_id: facility_2.facility_group.id
)

Note.find_or_create_by(
  noteable_type: 'FacilityProject',
  noteable_id: facility_project_2.id,
  user_id: admin.id,
  body: 'Test Note 2'
)

test_task_2 = Task.find_or_create_by(
  text: 'Test Task 2',
  description: 'Test task 2 description',
  start_date: Date.today + 1.day,
  due_date: Date.today + 6.days,
  task_type_id: task_type.id,
  task_stage_id: task_stage.id,
  facility_project_id: facility_project_2.id,
  watched: true,
  progress: 40
)

TaskUser.find_or_create_by(task_id: test_task_2.id, user_id: admin.id)

new_task_2 = Task.find_or_create_by(
  text: 'New Task 2',
  description: 'New task 2 description',
  start_date: Date.today + 1.day,
  due_date: Date.today + 6.days,
  task_type_id: task_type.id,
  task_stage_id: new_task_stage.id,
  facility_project_id: facility_project_2.id,
  watched: false,
  progress: 40
)

TaskUser.find_or_create_by(task_id: new_task_2.id, user_id: client.id)

test_issue_2 = Issue.find_or_create_by(
  title: 'Test Issue 2',
  description: 'Test issue 2 description',
  start_date: Date.today + 1.day,
  due_date: Date.today + 6.days,
  issue_type_id: issue_type.id,
  task_type_id: task_type.id,
  issue_stage_id: issue_stage.id,
  issue_severity_id: issue_severity.id,
  facility_project_id: facility_project_2.id,
  watched: true,
  progress: 40
)

IssueUser.find_or_create_by(issue_id: test_issue_2.id, user_id: admin.id)

new_issue_2 = Issue.find_or_create_by(
  title: 'New Issue 2',
  description: 'New issue 2 description',
  start_date: Date.today + 1.day,
  due_date: Date.today + 6.days,
  issue_type_id: issue_type.id,
  task_type_id: task_type.id,
  issue_stage_id: new_issue_stage.id,
  issue_severity_id: issue_severity.id,
  facility_project_id: facility_project_2.id,
  watched: false,
  progress: 40
)

IssueUser.find_or_create_by(issue_id: new_issue_2.id, user_id: client.id)

test_risk_2 = Risk.find_or_create_by(
  text: 'Test Risk 2',
  risk_description: 'Test Risk 2 description',
  impact_description: 'Test Risk 2 impact description',
  start_date: Date.today + 1.day,
  due_date: Date.today + 6.days,
  risk_approach_description: 'Test Risk 2 approach description',
  probability_description: 'Test Risk 2 probability description',
  user_id: admin.id,
  facility_project_id: facility_project_2.id,
  task_type_id: task_type.id,
  risk_stage_id: risk_stage.id,
  watched: true,
  progress: 40
)
test_risk_2.checklists.create(text: "Risk Checklist1", user_id: client.id)
test_risk_2.checklists.create(text: "Risk Checklist1", user_id: admin.id)

RiskUser.find_or_create_by(risk_id: test_risk_2.id, user_id: admin.id)

new_risk_2 = Risk.find_or_create_by(
  text: 'New Risk 2',
  risk_description: 'New Risk 2 description',
  impact_description: 'New Risk 2 impact description',
  start_date: Date.today + 1.day,
  due_date: Date.today + 6.days,
  risk_approach_description: 'New Risk 2 approach description',
  probability_description: 'New Risk 2 probability description',
  user_id: client.id,
  facility_project_id: facility_project_2.id,
  task_type_id: task_type.id,
  risk_stage_id: new_risk_stage.id,
  watched: false,
  progress: 40
)
new_risk_2.checklists.create(text: "Risk Checklist2", user_id: client.id)
new_risk_2.checklists.create(text: "Risk Checklist2", user_id: admin.id)

RiskUser.find_or_create_by(risk_id: new_risk_2.id, user_id: client.id)

new_lesson_2 = Lesson.find_or_create_by({
  "title" =>"Test Lesson 2",
  "description"=>"hello",
  "date"=>DateTime.now,
  "stage"=>nil,
  "task_type_id"=>task_type.id,
  "user_id"=>client.id,
  "important"=>false,
  "facility_project_id"=>facility_project_2.id,
  "reportable"=>false,
  "draft"=>false
})

facility_group_2 = FacilityGroup.find_or_create_by(
  name: 'Test Facility Group 2',
  code: 'TFG2',
  status: 'active'
)
facility_3 = Facility.find_or_create_by(
  facility_name: 'Test Facility 3',
  address: '2-20 Western Rd, Park Royal, London NW10 7LW, UK',
  point_of_contact: 'Test points',
  phone_number: '+447400123453',
  email: 'facility3@test.com',
  lat: '51.5285739',
  lng: '-0.2696692999999999' ,
  status: 'active',
  country_code: 'GB',
  creator_id: admin.id,
  facility_group_id: facility_group_2.id
)

facility_project_3 = FacilityProject.find_or_create_by(
  project_id: project.id,
  facility_id: facility_3.id,
  status_id: active_status.id,
  due_date: Date.today + 10.days,
  facility_group_id: facility_3.facility_group.id
)

Note.find_or_create_by(
  noteable_type: 'FacilityProject',
  noteable_id: facility_project_3.id,
  user_id: admin.id,
  body: 'Test Note 3'
)

test_task_3 = Task.find_or_create_by(
  text: 'Test Task 3',
  description: 'Test task 3 description',
  start_date: Date.today - 1.day,
  due_date: Date.today + 4.days,
  task_type_id: task_type.id,
  task_stage_id: task_stage.id,
  facility_project_id: facility_project_3.id,
  watched: true,
  progress: 70
)

TaskUser.find_or_create_by(task_id: test_task_3.id, user_id: admin.id)

new_task_3 = Task.find_or_create_by(
  text: 'New Task 3',
  description: 'New task 3 description',
  start_date: Date.today + 1.day,
  due_date: Date.today + 6.days,
  task_type_id: task_type.id,
  task_stage_id: new_task_stage.id,
  facility_project_id: facility_project_3.id,
  watched: false,
  progress: 70
)

TaskUser.find_or_create_by(task_id: new_task_3.id, user_id: client.id)

test_issue_3 = Issue.find_or_create_by(
  title: 'Test Issue 3',
  description: 'Test issue 3 description',
  start_date: Date.today - 1.day,
  due_date: Date.today + 4.days,
  issue_type_id: issue_type.id,
  task_type_id: task_type.id,
  issue_stage_id: issue_stage.id,
  issue_severity_id: issue_severity.id,
  facility_project_id: facility_project_3.id,
  watched: true,
  progress: 70
)

IssueUser.find_or_create_by(issue_id: test_issue_3.id, user_id: admin.id)

new_issue_3 = Issue.find_or_create_by(
  title: 'New Issue 3',
  description: 'New issue 3 description',
  start_date: Date.today + 1.day,
  due_date: Date.today + 6.days,
  issue_type_id: issue_type.id,
  task_type_id: task_type.id,
  issue_stage_id: new_issue_stage.id,
  issue_severity_id: issue_severity.id,
  facility_project_id: facility_project_3.id,
  watched: false,
  progress: 40
)

IssueUser.find_or_create_by(issue_id: new_issue_3.id, user_id: client.id)

test_risk_3 = Risk.find_or_create_by(
  text: 'Test Risk 3',
  risk_description: 'Test Risk 3 description',
  impact_description: 'Test Risk 3 impact description',
  start_date: Date.today + 1.day,
  due_date: Date.today + 6.days,
  risk_approach_description: 'Test Risk 3 approach description',
  probability_description: 'Test Risk 3 probability description',
  user_id: admin.id,
  facility_project_id: facility_project_3.id,
  task_type_id: task_type.id,
  risk_stage_id: risk_stage.id,
  watched: true,
  progress: 70
)
test_risk_3.checklists.create(text: "Risk Checklist2", user_id: client.id)
test_risk_3.checklists.create(text: "Risk Checklist2", user_id: admin.id)

RiskUser.find_or_create_by(risk_id: test_risk_3.id, user_id: admin.id)

new_risk_3 = Risk.find_or_create_by(
  text: 'New Risk 3',
  risk_description: 'New Risk 3 description',
  impact_description: 'New Risk 3 impact description',
  start_date: Date.today + 1.day,
  due_date: Date.today + 6.days,
  risk_approach_description: 'New Risk 3 approach description',
  probability_description: 'New Risk 3 probability description',
  user_id: client.id,
  facility_project_id: facility_project_3.id,
  task_type_id: task_type.id,
  risk_stage_id: new_risk_stage.id,
  watched: false,
  progress: 40
)
new_risk_3.checklists.create(text: "Risk Checklist2", user_id: client.id)
new_risk_3.checklists.create(text: "Risk Checklist2", user_id: admin.id)

RiskUser.find_or_create_by(risk_id: new_risk_3.id, user_id: client.id)

new_lesson_3 = Lesson.find_or_create_by({
  "title" =>"Test Lesson 3",
  "description"=>"hello",
  "date"=>DateTime.now,
  "stage"=>nil,
  "task_type_id"=>task_type.id,
  "user_id"=>client.id,
  "important"=>false,
  "facility_project_id"=>facility_project_3.id,
  "reportable"=>false,
  "draft"=>false
})

facility_4 = Facility.find_or_create_by(
  facility_name: 'Test Facility 4',
  address: 'Axford, Marlborough SN8, UK',
  point_of_contact: 'Test points',
  phone_number: '+447400123454',
  email: 'facility4@test.com',
  lat: '23.6966410',
  lng: '32.7181357' ,
  status: 'active',
  country_code: 'GB',
  creator_id: client.id,
  facility_group_id: facility_group_2.id
)

facility_project_4 = FacilityProject.find_or_create_by(
  project_id: project.id,
  facility_id: facility_4.id,
  status_id: inactive_status.id,
  due_date: Date.today + 10.days,
  facility_group_id: facility_4.facility_group.id
)

Note.find_or_create_by(
  noteable_type: 'FacilityProject',
  noteable_id: facility_project_4.id,
  user_id: admin.id,
  body: 'Test Note 4'
)

test_task_4 = Task.find_or_create_by(
  text: 'Test Task 4',
  description: 'Test task description',
  start_date: Date.today + 2.days,
  due_date: Date.today + 7.days,
  task_type_id: task_type.id,
  task_stage_id: task_stage.id,
  facility_project_id: facility_project_4.id,
  progress: 100
)

TaskUser.find_or_create_by(task_id: test_task_4.id, user_id: admin.id)

new_task_4 = Task.find_or_create_by(
  text: 'New Task 4',
  description: 'New task 4 description',
  start_date: Date.today + 1.day,
  due_date: Date.today + 6.days,
  task_type_id: task_type.id,
  task_stage_id: new_task_stage.id,
  facility_project_id: facility_project_4.id,
  watched: false,
  progress: 70
)

TaskUser.find_or_create_by(task_id: new_task_4.id, user_id: client.id)
test_issue_4 = Issue.find_or_create_by(
  title: 'Test Issue 4',
  description: 'Test issue description',
  start_date: Date.today + 2.days,
  due_date: Date.today + 7.days,
  issue_type_id: issue_type.id,
  task_type_id: task_type.id,
  issue_stage_id: issue_stage.id,
  issue_severity_id: issue_severity.id,
  facility_project_id: facility_project_4.id,
  progress: 100
)

IssueUser.find_or_create_by(issue_id: test_issue_4.id, user_id: admin.id)

new_issue_4 = Issue.find_or_create_by(
  title: 'New Issue 4',
  description: 'New issue 4 description',
  start_date: Date.today + 1.day,
  due_date: Date.today + 6.days,
  issue_type_id: issue_type.id,
  task_type_id: task_type.id,
  issue_stage_id: new_issue_stage.id,
  issue_severity_id: issue_severity.id,
  facility_project_id: facility_project_4.id,
  watched: false,
  progress: 40
)

IssueUser.find_or_create_by(issue_id: new_issue_4.id, user_id: client.id)

test_risk_4 = Risk.find_or_create_by(
  text: 'Test Risk 4',
  risk_description: 'Test Risk 4 description',
  impact_description: 'Test Risk 4 impact description',
  start_date: Date.today + 1.day,
  due_date: Date.today + 6.days,
  risk_approach_description: 'Test Risk 4 approach description',
  probability_description: 'Test Risk 4 probability description',
  user_id: admin.id,
  facility_project_id: facility_project_4.id,
  task_type_id: task_type.id,
  risk_stage_id: risk_stage.id,
  progress: 100
)
test_risk_4.checklists.create(text: "Risk Checklist4", user_id: admin.id)
test_risk_4.checklists.create(text: "Risk Checklist4", user_id: client.id)

RiskUser.find_or_create_by(risk_id: test_risk_4.id, user_id: admin.id)

new_risk_4 = Risk.find_or_create_by(
  text: 'New Risk 4',
  risk_description: 'New Risk 4 description',
  impact_description: 'New Risk 4 impact description',
  start_date: Date.today + 1.day,
  due_date: Date.today + 6.days,
  risk_approach_description: 'New Risk 4 approach description',
  probability_description: 'New Risk 4 probability description',
  user_id: client.id,
  facility_project_id: facility_project_4.id,
  task_type_id: task_type.id,
  risk_stage_id: new_risk_stage.id,
  watched: false,
  progress: 40
)
new_risk_4.checklists.create(text: "Risk Checklist5", user_id: admin.id)
new_risk_4.checklists.create(text: "Risk Checklist5", user_id: client.id)

RiskUser.find_or_create_by(risk_id: new_risk_4.id, user_id: client.id)

new_lesson_3 = Lesson.find_or_create_by({
  "title" =>"Test Lesson 4",
  "description"=>"hello",
  "date"=>DateTime.now,
  "stage"=>nil,
  "task_type_id"=>task_type.id,
  "user_id"=>client.id,
  "important"=>false,
  "facility_project_id"=>facility_project_4.id,
  "reportable"=>false,
  "draft"=>false
})