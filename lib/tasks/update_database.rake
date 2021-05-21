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

desc "Modify User privileges for array"
task :modify_user_privileges => :environment do

  puts "Modifying data type for privileges"
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

desc "Add Project privileges for User"
task :create_project_privileges => :environment do

  Privilege.all.each do |privilege|
    privilege_attr = privilege.attributes.except("id", "created_at", "updated_at", "user_id", "project_id", "group_number").clone
    c = false
    privilege_attr.each do |k,v|
      if v.is_a?(String)
        privilege_attr[k] = v.chars
        c = true
      end
    end
    privilege.update(privilege_attr) if c
  end

  puts "Adding Project privileges for User"
  User.all.each do |user|
    privilege = user.privilege
    privilege_attr = privilege.attributes.except("id", "created_at", "updated_at", "user_id", "project_id", "group_number", "facility_manager_view","map_view", "gantt_view", "watch_view", "documents", "members", "sheets_view", "kanban_view", "calendar_view" ).clone

    privilege_attr.merge!(user_id: user.id, project_ids: user.project_ids)
    p = ProjectPrivilege.create(privilege_attr)
  end
end