desc "Convert privilege data to roles"
task :convert_privilege_roles => :environment do
  
  PROJECT_PRIVILEGS_ROLE_TYPES = ["project_analytics", "project_tasks", "project_issues", "project_risks", "project_lessons", "project_notes"]
  CONTRACT_PRIVILEGS_ROLE_TYPES = ["contract_analytics", "contract_tasks", "contract_issues", "contract_risks", "contract_lessons", "contract_notes"]
  PROGRAM_SETTINGS_ROLE_TYPES = ["program_setting_groups", "program_setting_users_roles", "program_setting_projects", "program_setting_contracts" ]


  def assign_default_roles_to_users
    role_ids = Role.where(name: ["untitled role-1", "untitled role-2", "untitled role-3"]).pluck(:id)
    role_users = []
    users = User.includes(:role_users, :projects)
    users.in_batches(of: 500) do |users|
      users.find_each do |user|
        next if user.role_users.where("role_users.role_id in (?)", role_ids).count > 0

        project_ids = user.project_ids
        project_ids.each do |pid|
          role_ids.each do |role_id|          
            role_users << RoleUser.new(user_id: user.id, role_id: role_id, project_id: pid)
          end
        end
      end
    end
    RoleUser.import(role_users)
  end

  def create_project_privileges_roles
    new_roles = []
    ProjectPrivilege.all.each do |pp|
      role_name = "ProjectPrivilegeRole#{pp.id}"
      
      if (["R", "D", "W"] - pp.admin).size == 0 # i.e. program_admin
        program_admin_role = Role.create(name: role_name, is_portfolio: false)
        new_roles << program_admin_role
        
        program_admin_role_privilege = program_admin_role.role_privileges.create([
          {name: "program_setting_users_roles", privilege: "RWD",role_type: "program_setting_users_roles"}
        ])
        user_id = pp.user_id
        assign_roles = []
        pp.project_ids.each do |pid|
          assign_roles << {user_id: user_id, program_id: pid.to_i}
        end
    
        assign_roles.each do |hash|
          user_id = hash[:user_id]
          program_id = hash[:program_id]
          user = User.find user_id
          role_users = user.role_users.create([
            {role_id: program_admin_role.id, project_id: program_id}
          ])
        end    
      end
    end

  end

  def create_facility_privileges_roles
    new_roles = []
    FacilityPrivilege.all.each do |pp|
      role_name = "FacilityPrivilegeRole#{pp.id}"

      facility_privilege_role = Role.create(name: role_name, is_portfolio: false)
      new_roles << facility_privilege_role
      project_id = pp.project_id

      facility_project_ids = FacilityProject.where(project_id: project_id, facility_id: pp.facility_project_ids).pluck(:id)
      
      ["overview", "tasks", "notes", "issues", "risks", "lessons"].each do |attr|

        value = pp.send(attr)
        role_privilege_name = nil
        role_privilege_name = "project_analytics" if attr == "overview"
        role_privilege_name = "project_tasks" if attr == "tasks"
        role_privilege_name = "project_notes" if attr == "notes"
        role_privilege_name = "project_issues" if attr == "issues"
        role_privilege_name = "project_risks" if attr == "risks"
        role_privilege_name = "project_lessons" if attr == "lessons"
        
        next if role_privilege_name.nil?

        if (["R", "D", "W"] & value).size > 0          
          facility_privilege_role_privilege = facility_privilege_role.role_privileges.create([
            {name: role_privilege_name, privilege: value.join ,role_type: role_privilege_name}
          ])
          user_id = pp.user_id
          assign_roles = []
          facility_project_ids.each do |pid|
            assign_roles << {user_id: user_id, facility_project_id: pid.to_i}
          end
      
          assign_roles.each do |hash|
            user_id = hash[:user_id]
            facility_project_id = hash[:facility_project_id]
            user = User.find user_id
            role_users = user.role_users.create([
              {role_id: facility_privilege_role.id, facility_project_id: facility_project_id}
            ])
          end      
        end
      end
    end
  end

  def create_contract_privileges_roles
    new_roles = []
    ContractPrivilege.all.each do |pp|
      role_name = "ContractPrivilegeRole#{pp.id}"

      contract_privilege_role = Role.create(name: role_name, is_portfolio: false)
      new_roles << contract_privilege_role
      project_id = pp.project_id

      contract_ids = pp.contract_ids
      
      ["overview", "tasks", "notes", "issues", "risks", "lessons"].each do |attr|

        value = pp.send(attr)
        role_privilege_name = nil
        role_privilege_name = "contract_analytics" if attr == "overview"
        role_privilege_name = "contract_tasks" if attr == "tasks"
        role_privilege_name = "contract_notes" if attr == "notes"
        role_privilege_name = "contract_issues" if attr == "issues"
        role_privilege_name = "contract_risks" if attr == "risks"
        role_privilege_name = "contract_lessons" if attr == "lessons"
        
        next if role_privilege_name.nil?

        if (["R", "D", "W"] & value).size > 0          
          contract_privilege_role_privilege = contract_privilege_role.role_privileges.create([
            {name: role_privilege_name, privilege: value.join ,role_type: role_privilege_name}
          ])
          user_id = pp.user_id
          assign_roles = []
          contract_ids.each do |pid|
            assign_roles << {user_id: user_id, contract_id: pid.to_i}
          end
      
          assign_roles.each do |hash|
            user_id = hash[:user_id]
            contract_id = hash[:contract_id]
            user = User.find user_id
            role_users = user.role_users.create([
              {role_id: contract_privilege_role.id, contract_id: contract_id}
            ])
          end      
        end
      end
    end
  end

  puts "----- Creating Project Privilegs Roles -----"
  create_project_privileges_roles

  puts "----- Creating Facility Privileges Roles -----"
  create_facility_privileges_roles

  puts "----- Creating Contract Privileges Roles -----"
  create_contract_privileges_roles

  def show_project_privilege_count
    roles_count = 0
    role_privileges_count = 0
    role_users_count = 0
    new_roles = []
    role_data_hash = {}
  
    ProjectPrivilege.all.each do |pp|
      role_name = "ProgramPrivilegeRole#{pp.id}"
      
      if (["R", "D", "W"] - pp.admin).size == 0 # i.e. program_admin   
        roles_count += 1
        role_privileges_count += 1
        pp.project_ids.each do |pid|
          role_users_count += 1
        end
        role_data_hash[pp.id] = {
          roles_count: roles_count,
          role_privileges_count: role_privileges_count,
          role_users_count: role_users_count
        }
      end
    end
    puts "Project Privileges Roles Count"
    puts "--------------------------------"
    puts "Total Roles #{roles_count}"
    puts "Total Role privileges #{role_privileges_count}"
    puts "Total Role users #{role_users_count}"  

  end


  def show_facility_privilege_count
    roles_count = 0
    role_privileges_count = 0
    role_users_count = 0
    new_roles = []
    role_data_hash = {}
  
    FacilityPrivilege.all.each do |pp|
      role_name = "FacilityPrivilegeRole#{pp.id}"
      
      roles_count += 1
      role_privileges_count += PROJECT_PRIVILEGS_ROLE_TYPES.size
      pp.facility_project_ids.each do |pid|
        role_users_count += 1
      end
      role_data_hash[pp.id] = {
        roles_count: roles_count,
        role_privileges_count: role_privileges_count,
        role_users_count: role_users_count
      }
    end
    puts "Facility Privileges Roles Count"
    puts "--------------------------------"
    puts "Total Roles #{roles_count}"
    puts "Total Role privileges #{role_privileges_count}"
    puts "Total Role users #{role_users_count}"  

  end

  def show_contract_privilege_count
    roles_count = 0
    role_privileges_count = 0
    role_users_count = 0
    new_roles = []
    role_data_hash = {}
  
    ContractPrivilege.all.each do |pp|
      role_name = "ContractPrivilegeRole#{pp.id}"
      
      roles_count += 1
      role_privileges_count += CONTRACT_PRIVILEGS_ROLE_TYPES.size
      pp.contract_ids.each do |pid|
        role_users_count += 1
      end
      role_data_hash[pp.id] = {
        roles_count: roles_count,
        role_privileges_count: role_privileges_count,
        role_users_count: role_users_count
      }
    end
    puts "Contract Privileges Roles Count"
    puts "--------------------------------"
    puts "Total Roles #{roles_count}"
    puts "Total Role privileges #{role_privileges_count}"
    puts "Total Role users #{role_users_count}"  

  end

end