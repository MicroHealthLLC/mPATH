desc "Modify Roles"
task :modify_roles => :environment do

  roles = [
    {
      name: "update-project", 
      type_of: 'project',
      role_privileges: RolePrivilege::PROJECT_PRIVILEGES_ROLE_TYPES
    },
    {
      name: "read-project", 
      type_of: 'project',
      role_privileges: RolePrivilege::PROJECT_PRIVILEGES_ROLE_TYPES
    },
    {
      name: "contribute-project", 
      type_of: 'project',
      role_privileges: RolePrivilege::PROJECT_PRIVILEGES_ROLE_TYPES
    },
  
    {
      name: "update-contract", 
      type_of: 'contract',
      role_privileges: RolePrivilege::CONTRACT_PRIVILEGES_ROLE_TYPES
    },
    {
      name: "read-contract", 
      type_of: 'contract',
      role_privileges: RolePrivilege::CONTRACT_PRIVILEGES_ROLE_TYPES
    },
    {
      name: "contribute-contract", 
      type_of: 'contract',
      role_privileges: RolePrivilege::CONTRACT_PRIVILEGES_ROLE_TYPES
    },  
    {
      name: "program-admin",
      type_of: 'admin',
      role_privileges: RolePrivilege::PROGRAM_SETTINGS_ROLE_TYPES
    },
    {
      name: "program-admin-not-users",
      type_of: 'admin',
      role_privileges: (RolePrivilege::PROGRAM_SETTINGS_ROLE_TYPES - ["program_setting_users_roles"])
    },
    {
      name: "program-admin-not-contract",
      type_of: 'admin',
      role_privileges: ( RolePrivilege::PROGRAM_SETTINGS_ROLE_TYPES - ["program_setting_contracts"])
    },
  ]


  roles.each do |role_hash|
    role = Role.where(name: role_hash[:name]).first
    
    if !role
      puts "Role #{role_hash[:name]} does not exists!"
      next
    end
  
    role_privilege_names = role.role_privileges.pluck(:name)
    additional_rp = role_hash[:role_privileges] - role_privilege_names
    additional_rp.each do |rp|
      RolePrivilege.create(name: rp, role_type: rp, role_id: role.id, privilege: role_hash[:privilege] )
    end
  end

end