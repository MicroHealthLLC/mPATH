desc "Destroy Role related data"
task :destroy_role_data => :environment do
  
    # Since we can't destroy default roles record we will remove other related data
    puts "Deleting non default roles"
    Role.not_default_roles.destroy_all
    puts "Deleting remaining RoleUser data"
    RoleUser.destroy_all
end