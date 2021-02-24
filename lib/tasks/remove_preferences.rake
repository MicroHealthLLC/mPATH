desc "Remove user preferences"
task :remove_preferences => :environment do
  User.all.map{|u| u.settings(:preferences).destroy }
end