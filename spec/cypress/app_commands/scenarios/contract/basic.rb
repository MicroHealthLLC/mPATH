admin = User.find_or_initialize_by(email: 'admin@test.com')

client = User.find_or_initialize_by(email: 'client@test.com')

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

puts "Adding ContractAwaard To"
contract_award_to = ["awardto1"]
contract_award_to.each do |name|
  ContractAwardTo.find_or_create_by(name: name) do |s|
    s.name = name
    s.user_id = admin.id
  end
end

puts "Adding Contract pops"
contract_pops = ["contract pop1"]
contract_pops.each do |name|
  ContractPop.find_or_create_by(name: name) do |s|
    s.name = name
    s.user_id = admin.id
  end
end

puts "Adding Contract Naic"
contract_naics = ["contract Naic1"]
contract_naics.each do |name|
  ContractNaic.find_or_create_by(name: name) do |s|
    s.name = name
    s.user_id = admin.id
  end
end

puts "Adding Contract Award Type"
contract_award_types = ["contract award type 1"]
contract_award_types.each do |name|
  ContractAwardType.find_or_create_by(name: name) do |s|
    s.name = name
    s.user_id = admin.id
  end
end

project = Project.where(name: 'Test Project').first

facility_group_1 = FacilityGroup.where(name: 'Test Facility Group 1').first

# contract_1 = Contract.find_or_create_by(
#   name: "Test Contarct 1",
#   contract_type_id: ContractType.first.id,
#   project_code: "Project Code 123",
#   nickname: "Contract 1 Nickname",
#   project_id: project.id,
#   facility_group_id: facility_group_1.id,
#   user_id: admin.id
# )

# contract_2 = Contract.find_or_create_by(
#   name: "Test Contarct 2",
#   contract_type_id: ContractType.first.id,
#   project_code: "Project Code 123",
#   nickname: "Contract 2 Nickname",
#   project_id: project.id,
#   facility_group_id: facility_group_1.id,
#   user_id: client.id
# )

contract_project_data_1 = ContractProjectDatum.create({
  "charge_code"=>"charge code",
  "name"=>"Test Contract 1",
  "contract_customer_id"=>ContractCustomer.first.id,
  "contract_award_to_id"=>ContractAwardTo.first.id,
  "contract_type_id"=>ContractType.first.id,
  "prime_or_sub"=>"prime",
  "contract_start_date"=>"2022-10-18T19:35:39.000Z",
  "contract_end_date"=>"2022-11-28T19:00:15.000Z",
  "total_contract_value"=>"10000.145",
  "contract_pop_id"=>ContractPop.first.id,
  "contract_current_pop_id"=>ContractCurrentPop.first.id,
  "contract_current_pop_start_date"=>"2022-10-18T19:35:57.000Z",
  "contract_current_pop_end_date"=>"2022-10-18T19:36:07.000Z",
  "total_founded_value"=>"1000.147",
  "billings_to_date"=>nil,
  "comments"=>"comments",
  "created_at"=>"2022-06-14T19:20:53.727Z",
  "updated_at"=>"2022-10-26T19:01:27.440Z",
  "contract_naic_id"=>ContractNaic.first.id,
  "contract_vehicle_id"=>ContractVehicle.first.id,
  "contract_award_type_id"=>ContractAwardType.first.id,
  "user_id"=>admin.id,
  "number"=>nil,
  "co_contract_poc_id"=>0,
  "gov_contract_poc_id"=>0,
  "pm_contract_poc_id"=>0,
  "contract_number_id"=>ContractNumber.first.id,
  "notes"=>"",
  "ignore_expired"=>false
  })
 

contract_project_data_2 = ContractProjectDatum.create({
  "charge_code"=>"charge code",
  "name"=>"Test Contract 2",
  "contract_customer_id"=>ContractCustomer.first.id,
  "contract_award_to_id"=>ContractAwardTo.first.id,
  "contract_type_id"=>ContractType.first.id,
  "prime_or_sub"=>"prime",
  "contract_start_date"=>"2022-10-18T19:35:39.000Z",
  "contract_end_date"=>"2022-11-28T19:00:15.000Z",
  "total_contract_value"=>"10000.145",
  "contract_pop_id"=>ContractPop.first.id,
  "contract_current_pop_id"=>ContractCurrentPop.first.id,
  "contract_current_pop_start_date"=>"2022-10-18T19:35:57.000Z",
  "contract_current_pop_end_date"=>"2022-10-18T19:36:07.000Z",
  "total_founded_value"=>"1000.147",
  "billings_to_date"=>nil,
  "comments"=>"comments",
  "created_at"=>"2022-06-14T19:20:53.727Z",
  "updated_at"=>"2022-10-26T19:01:27.440Z",
  "contract_naic_id"=>ContractNaic.first.id,
  "contract_vehicle_id"=>ContractVehicle.first.id,
  "contract_award_type_id"=>ContractAwardType.first.id,
  "user_id"=>admin.id,
  "number"=>nil,
  "co_contract_poc_id"=>0,
  "gov_contract_poc_id"=>0,
  "pm_contract_poc_id"=>0,
  "contract_number_id"=>ContractNumber.first.id,
  "notes"=>"",
  "ignore_expired"=>false
  })

project_contracts = [
  {
    contract_project_datum_id: contract_project_data_1.id,
    project_id: project.id,
    facility_group_id: facility_group_1.id
  },
  {
    contract_project_datum_id: contract_project_data_2.id,
    project_id: project.id,
    facility_group_id: facility_group_1.id
  }
]
project_contracts.each do |project_contract|
  ProjectContract.create(project_contract)
end

program_admin_role = Role.program_admin_user_role
contract_update_role = Role.where(name: "update-contract").first

# RoleUser.new(project_id: project.id, user_id: client.id, role_id: program_admin_role.id, project_contract_id: contract_project_data_1.project_contracts.first.id ).save

RoleUser.new(project_id: project.id, project_contract_id: contract_project_data_1.project_contracts.first.id, user_id: client.id, role_id: contract_update_role.id ).save

project_contract_1 = ProjectContract.all[0]

task_type = TaskType.first
task_stage = TaskStage.first

test_task_1 = Task.find_or_create_by(
  text: 'Test Task 1',
  description: 'Test task 1 description',
  start_date: Date.today,
  due_date: Date.today + 5.days,
  task_type_id: task_type.id,
  task_stage_id: task_stage.id,
  project_contract_id: project_contract_1.id,
  watched: true,
  progress: 10
)

TaskUser.find_or_create_by(task_id: test_task_1.id, user_id: admin.id)
TaskUser.find_or_create_by(task_id: test_task_1.id, user_id: client.id)

project_contract_2 = ProjectContract.all[1]

new_task_1 = Task.find_or_create_by(
  text: 'New Task 1',
  description: 'New task 1 description',
  start_date: Date.today + 1.day,
  due_date: Date.today + 6.days,
  task_type_id: task_type.id,
  task_stage_id: task_stage.id,
  project_contract_id: project_contract_1.id,
  watched: true,
  progress: 70
)

TaskUser.find_or_create_by(task_id: new_task_1.id, user_id: client.id)
