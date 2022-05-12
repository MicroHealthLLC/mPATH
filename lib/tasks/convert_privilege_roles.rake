desc "Convert privilege data to roles"
task :convert_privilege_roles => :environment do
  
  PROJECT_PRIVILEGS_ROLE_TYPES = ["project_analytics", "project_tasks", "project_issues", "project_risks", "project_lessons", "project_notes"]
  CONTRACT_PRIVILEGS_ROLE_TYPES = ["contract_analytics", "contract_tasks", "contract_issues", "contract_risks", "contract_lessons", "contract_notes"]
  PROGRAM_SETTINGS_ROLE_TYPES = ["program_setting_groups", "program_setting_users_roles", "program_setting_projects", "program_setting_contracts" ]

  def assign_roles_using_program_privileges
    update_project_role_id = Role.find_by_name("update-project").id
    read_project_role_id = Role.find_by_name("read-project").id
    contribute_project_role_id = Role.find_by_name("contribute-project").id

    update_contract_role_id = Role.find_by_name("update-contract").id
    read_contract_role_id = Role.find_by_name("read-contract").id
    contribute_contract_role_id = Role.find_by_name("contribute-contract").id

    program_admin_role_id = Role.find_by_name("program-admin").id
    
    new_role_users = []
    all_role_users = []

    User.all.each do |user|

      pph = user.project_privileges_hash
      pph.each do |project_id, privileges_hash|
        project_id = project_id.to_i
        project = Project.where(id: project_id).first
        next if !project
        next if !privileges_hash["overview"] || !privileges_hash["tasks"] || !privileges_hash["notes"] || !privileges_hash["issues"] || !privileges_hash["risks"] || !privileges_hash["lessons"]

        if ( ["R", "D", "W"] & privileges_hash["overview"] ).size == 3 &&
          ( ["R", "D", "W"] & privileges_hash["tasks"] ).size == 3 &&
          ( ["R", "D", "W"] & privileges_hash["notes"] ).size == 3 &&
          ( ["R", "D", "W"] & privileges_hash["issues"] ).size == 3 &&
          ( ["R", "D", "W"] & privileges_hash["risks"] ).size == 3 &&
          ( ["R", "D", "W"] & privileges_hash["lessons"] ).size == 3
          
          next if user.role_users.where(role_id: program_admin_role_id, project_id: project_id ).count > 0 || new_role_users.detect{|ru| ru.role_id == program_admin_role_id  &&  ru.project_id == project_id} 

          new_role_users << RoleUser.new(user_id: user.id, role_id: program_admin_role_id, project_id: project_id)  

        elsif ( ["R"] & privileges_hash["overview"] ).size == 1 &&
          ( ["R"] & privileges_hash["tasks"] ).size == 1 &&
          ( ["R"] & privileges_hash["notes"] ).size == 1 &&
          ( ["R"] & privileges_hash["issues"] ).size == 1 &&
          ( ["R"] & privileges_hash["risks"] ).size == 1 &&
          ( ["R"] & privileges_hash["lessons"] ).size == 1
          
          if !project.user_ids.include?(user.id)
            ProjectUser.create(project_id: project_id, user_id: user.id)
          end
        end

      end

      fph = user.facility_privileges_hash
      fph.each do |project_id, fph2|
        facility_projects = FacilityProject.where( project_id: project_id)
        project_id = project_id.to_i
        project = Project.where(id: project_id).first
        next if !project      
        fph2.each do |facility_id, privileges_hash|
          facility_project_id = facility_projects.detect{|fp| fp.facility_id == facility_id.to_i }.id
          # puts privileges_hash
          # puts "User id #{user.id}"
          # puts "Project id #{project_id}"
          # puts "fph2 id #{facility_id}"
          # puts "fph2 id #{privileges_hash["overview"]}"
          next if !privileges_hash["overview"] || !privileges_hash["tasks"] || !privileges_hash["notes"] || !privileges_hash["issues"] || !privileges_hash["risks"] || !privileges_hash["lessons"]

          if ( ["R", "D", "W"] & privileges_hash["overview"] ).size == 3 &&
            ( ["R", "D", "W"] & privileges_hash["tasks"] ).size == 3 &&
            ( ["R", "D", "W"] & privileges_hash["notes"] ).size == 3 &&
            ( ["R", "D", "W"] & privileges_hash["issues"] ).size == 3 &&
            ( ["R", "D", "W"] & privileges_hash["risks"] ).size == 3 &&
            ( ["R", "D", "W"] & privileges_hash["lessons"] ).size == 3
            
            next if user.role_users.where(role_id: update_project_role_id, facility_project_id:  facility_project_id,project_id: project_id ).count > 0 || new_role_users.detect{|ru| ru.role_id == update_project_role_id && ru.facility_project_id == facility_project_id  &&  ru.project_id == project_id} 

            new_role_users << RoleUser.new(user_id: user.id, role_id: update_project_role_id, facility_project_id: facility_project_id, project_id: project_id)

          elsif ( ["R", "W"] & privileges_hash["overview"] ).size == 2 &&
            ( ["R", "W"] & privileges_hash["tasks"] ).size == 2 &&
            ( ["R", "W"] & privileges_hash["notes"] ).size == 2 &&
            ( ["R", "W"] & privileges_hash["issues"] ).size == 2 &&
            ( ["R", "W"] & privileges_hash["risks"] ).size == 2 &&
            ( ["R", "W"] & privileges_hash["lessons"] ).size == 2

            next if user.role_users.where(role_id: contribute_project_role_id, facility_project_id:  facility_project_id,project_id:project_id ).count > 0 || new_role_users.detect{|ru| ru.role_id == contribute_project_role_id && ru.facility_project_id == facility_project_id  &&  ru.project_id == project_id} 

            new_role_users << RoleUser.new(user_id: user.id, role_id: contribute_project_role_id, facility_project_id: facility_project_id, project_id: project_id)


          elsif ( ["R"] & privileges_hash["overview"] ).size == 1 &&
            ( ["R"] & privileges_hash["tasks"] ).size == 1 &&
            ( ["R"] & privileges_hash["notes"] ).size == 1 &&
            ( ["R"] & privileges_hash["issues"] ).size == 1 &&
            ( ["R"] & privileges_hash["risks"] ).size == 1 &&
            ( ["R"] & privileges_hash["lessons"] ).size == 1

            next if user.role_users.where(role_id: read_project_role_id, facility_project_id:  facility_project_id,project_id:project_id ).count > 0 || new_role_users.detect{|ru| ru.role_id == read_project_role_id && ru.facility_project_id == facility_project_id  &&  ru.project_id == project_id} 

            new_role_users << RoleUser.new(user_id: user.id, role_id: read_project_role_id, facility_project_id: facility_project_id, project_id: project_id)            

          end
        end
      end

      cph = user.contract_privileges_hash
      cph.each do |project_id, cph2|
        project_id = project_id.to_i
        project = Project.where(id: project_id).first
        next if !project
        cph2.each do |contract_id, privileges_hash|
          next if contract_id == "authorized_contract_ids"
          contract_id  = contract_id.to_i
          # puts privileges_hash
          # puts "User id #{user.id}"
          # puts "Project id #{project_id}"
          # puts "fph2 id #{contract_id}"
          # puts "fph2 id #{privileges_hash["overview"]}"
          next if !privileges_hash["overview"] || !privileges_hash["tasks"] || !privileges_hash["notes"] || !privileges_hash["issues"] || !privileges_hash["risks"] || !privileges_hash["lessons"]

          if ( ["R", "D", "W"] & privileges_hash["overview"] ).size == 3 &&
            ( ["R", "D", "W"] & privileges_hash["tasks"] ).size == 3 &&
            ( ["R", "D", "W"] & privileges_hash["notes"] ).size == 3 &&
            ( ["R", "D", "W"] & privileges_hash["issues"] ).size == 3 &&
            ( ["R", "D", "W"] & privileges_hash["risks"] ).size == 3 &&
            ( ["R", "D", "W"] & privileges_hash["lessons"] ).size == 3
            
            next if user.role_users.where(role_id: update_contract_role_id, contract_id:  contract_id,project_id: project_id ).count > 0 || new_role_users.detect{|ru| ru.role_id == update_contract_role_id && ru.contract_id == contract_id  &&  ru.project_id == project_id} 

            new_role_users << RoleUser.new(user_id: user.id, role_id: update_contract_role_id, contract_id: contract_id, project_id: project_id)

          elsif ( ["R", "W"] & privileges_hash["overview"] ).size == 2 &&
            ( ["R", "W"] & privileges_hash["tasks"] ).size == 2 &&
            ( ["R", "W"] & privileges_hash["notes"] ).size == 2 &&
            ( ["R", "W"] & privileges_hash["issues"] ).size == 2 &&
            ( ["R", "W"] & privileges_hash["risks"] ).size == 2 &&
            ( ["R", "W"] & privileges_hash["lessons"] ).size == 2

            next if user.role_users.where(role_id: contribute_contract_role_id, contract_id:  contract_id,project_id:project_id ).count > 0 || new_role_users.detect{|ru| ru.role_id == contribute_contract_role_id && ru.contract_id == contract_id  &&  ru.project_id == project_id} 

            new_role_users << RoleUser.new(user_id: user.id, role_id: contribute_contract_role_id, contract_id: contract_id, project_id: project_id)

          elsif ( ["R"] & privileges_hash["overview"] ).size == 1 &&
            ( ["R"] & privileges_hash["tasks"] ).size == 1 &&
            ( ["R"] & privileges_hash["notes"] ).size == 1 &&
            ( ["R"] & privileges_hash["issues"] ).size == 1 &&
            ( ["R"] & privileges_hash["risks"] ).size == 1 &&
            ( ["R"] & privileges_hash["lessons"] ).size == 1

            next if user.role_users.where(role_id: read_contract_role_id, contract_id: contract_id, project_id:project_id ).count > 0 || new_role_users.detect{|ru| ru.role_id == read_contract_role_id && ru.contract_id == contract_id  &&  ru.project_id == project_id} 

            new_role_users << RoleUser.new(user_id: user.id, role_id: read_contract_role_id, contract_id: contract_id, project_id: project_id)            

          end

        end
      end

    end
    RoleUser.import(new_role_users)
  end
  puts "----- Assigning Roles using Program privileges -----"
  assign_roles_using_program_privileges

  def assign_default_roles_to_users
    role_ids = Role.where(name: ["update-project"]).pluck(:id)
    role_users = []
    users = User.includes(:role_users, :projects, :facility_projects)
    users.in_batches(of: 500) do |users|
      users.find_each do |user|
        next if user.role_users.where("role_users.role_id in (?)", role_ids).count > 0

        # project_ids = user.project_ids
        # project_ids.each do |pid|
        #   role_ids.each do |role_id|          
        #     role_users << RoleUser.new(user_id: user.id, role_id: role_id, project_id: pid)
        #   end
        # end
        facility_projects = user.facility_projects

        facility_projects.each do |fp|
          role_ids.each do |role_id|
            project_id = fp.project_id
            role_users << RoleUser.new(user_id: user.id, role_id: role_id, facility_project_id: fp.id, project_id: project_id)
          end
        end
      end
    end
    RoleUser.import(role_users)
  end

  # puts "----- Assigning Default Roles -----"
  # assign_default_roles_to_users

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

  # puts "----- Creating Project Privilegs Roles -----"
  # create_project_privileges_roles

  # puts "----- Creating Facility Privileges Roles -----"
  # create_facility_privileges_roles

  # puts "----- Creating Contract Privileges Roles -----"
  # create_contract_privileges_roles

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