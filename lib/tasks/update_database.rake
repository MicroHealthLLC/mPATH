desc "Update Progress"
task :update_progress => :environment do

  puts "Updating Facility Projects Progress"
  FacilityProject.all.map(&:update_progress)
  FacilityProject.all.map(&:update_color)

  puts "Updating Projects Progress"
  Project.all.map(&:update_progress)

  puts "Updating Task Type Progress"
  TaskType.all.map(&:update_progress)

  puts "Updating Facility Groups Progress"
  FacilityGroup.all.map(&:update_progress)
end

desc "Remove Query filters without Favorite filters"
task :remove_query_filters => :environment do

  puts "Removing Query Filters without Favorite filters"
  QueryFilter.where(favorite_filter_id: nil).destroy_all

end

desc "Update Existing privileges"
task :update_privileges => :environment do

  users = User.all
  users.each do |user|
    privilege = user.privilege
    next if !privilege
    h = privilege.attributes
    update_att = {}
    h.each do |k,v|
      next if ["user_id", "created_at", "updated_at", "id"].include?(k) || privilege.send(k).is_a?(Array)
      o = []
      o << "R" if privilege.send(k).include?("R")
      o << "W" if privilege.send(k).include?("W")
      o << "D" if privilege.send(k).include?("D")
      update_att[k] = o
    end
    privilege.update(update_att)
  end

end