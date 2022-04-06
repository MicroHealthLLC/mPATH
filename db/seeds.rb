
puts "Seed the application..."

user = User.find_or_initialize_by(email: 'admin@example.com') do |user|  
  user.password = 'adminPa$$w0rd'
  user.password_confirmation = 'adminPa$$w0rd'
  user.title = 'Mr.'
  user.first_name =  'Super'
  user.role = "superadmin"
  user.last_name =  'Admin'
end

if user.privilege.nil?
  user.privilege = Privilege.new(calendar_view: "R", settings_view: "RWD", lessons: "RWD", overview: "RWD", tasks: "RWD", notes: "RWD", issues: "RWD", admin: "RWD", map_view: "RWD", gantt_view: "RWD", watch_view: "RWD", documents: "RWD", members: "RWD")
  # user.privilege = Privilege.new(lessons: ["R"],calendar_view: ["R"], risks: ["R"],kanban_view: ["R"],sheets_view: ["R"], facility_manager_view: ["R"], overview: ["R", "W", "D"], tasks: ["R", "W", "D"], notes: ["R", "W", "D"], issues: ["R", "W", "D"], admin: ["R", "W", "D"], map_view: ["R", "W", "D"], gantt_view: ["R", "W", "D"], watch_view: ["R", "W", "D"], documents: ["R", "W", "D"], members: ["R", "W", "D"])
end

user.save(validate: false)

puts "superuser created with email: #{user.email}"

FacilityGroup.find_or_create_by(name: 'Sample Group', code: 'SAMP', status: 'active')
FacilityGroup.find_or_create_by(name: 'Unassigned', code: 'UNAS', status: 'active')
Setting.first_or_create(google_map_key: ENV['GOOGLE_MAP_KEY'])

Status.find_or_create_by(name: "Not Started", color: "#000000")

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


puts "Adding Contract types"
contract_types = [ "Prime Contract", "Non Prime contract", "Prime vehicles and ID IQs"]
contract_types.each do |name|
  ContractType.find_or_create_by(name: name) do |s|
    s.name = name
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
  end
end

puts "Adding Contract vehicles"
contract_vehicles = ["VAEHRM","Connections II","GSA IT-70 SIN 132-51","T4NG","8(a) STARS2","GSA IT-70","GSA PSS","DIA ESITA 2","WITS 3","CIO-SP3 (SDVOSB)","GAS","GSA IT-70 SIN 132-56","VETS 2 GWAC ","TBA","N/A"]
contract_vehicles.each do |name|
  ContractVehicle.find_or_create_by(name: name) do |s|
    s.name = name
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

puts "Adding default system roles"

roles = [
  {
    role_type: "update-project", 
    type_of: 'project',
    role_privileges: RolePrivilege::PROJECT_PRIVILEGS_ROLE_TYPES.map{ |role_privilege| {name: role_privilege, privilege: "RWD",role_type: role_privilege} }
  },
  {
    role_type: "program-admin",
    type_of: 'admin',
    role_privileges: RolePrivilege::PROGRAM_SETTINGS_ROLE_TYPES.map{ |role_privilege| {name: role_privilege, privilege: "RWD",role_type: role_privilege} }
    }
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

puts "Seeds completed.."
