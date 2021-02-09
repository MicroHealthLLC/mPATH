desc "Update assigned user"
task :update_assign_users => :environment do

  puts "Updating Assign users"
  ["Task", "Risk", "Issue"].each do |resource_class|
    all_resources = resource_class.constantize.all

    all_resources.each do |resource|
      
      resource_users = resource.send("#{resource_class.downcase}_users")
      # if only 1 user is available then it is responsible
      next if resource_users.size < 2

      # if 2 users are available then make 2nd one to accountable
      if resource_users.size == 2
        resource_users[1].update(user_type: "accountable")

      # if more than 2 users are available then make 1st responsible 2nd accountable and 2 to consulted and others to informed
      elsif resource_users.size > 2
        resource_users[1].update(user_type: "accountable")
        resource_users.each_with_index do |ts, index|
          next if index < 2
          ts.update(user_type: "consulted")
        end
      end
    end
  end

end