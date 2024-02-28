desc 'Update ActiveStorage blob data'
task :update_active_storage_blob => :environment do
  ActiveStorage::Attachment.in_batches(of: 1000) do |active_storage_attachments|
    active_storage_attachments.each do |attachment|
      attachment.blob.update(record_id: attachment.record_id, record_type: attachment.record_type, name: attachment.name)
    end
  end
  ActiveStorage::Blob.in_batches(of: 1000) do |active_storage_blobs|
    active_storage_blobs.each do |blob|
      result = blob.key.scan(/.{1,2}/)[0..1].join("/")
      old_file_path = "#{Rails.root}/storage/#{result}/#{blob.key}"
      new_file_path = "#{Rails.root}/storage/#{result}/#{blob.filename}"
      begin
        FileUtils.cp(old_file_path,new_file_path)
      rescue Exception => e
        puts "Exception : #{e.message}"
      end
    end
  end
end

desc 'Move existing POC records to multiple as feature is changed'
task :move_existing_poc_to_multiple => :environment do
  ContractProjectDatum.all.each do |contract_project_data|
    pm_contract_poc_id = [contract_project_data.pm_contract_poc_id]
    gov_contract_poc_id = [contract_project_data.gov_contract_poc_id]
    co_contract_poc_id = [contract_project_data.co_contract_poc_id]
    contract_project_data.add_contract_pocs(pm_contract_poc_id, ContractProjectPoc::PROGRAM_MANAGER_POC_TYPE )
    contract_project_data.add_contract_pocs(gov_contract_poc_id, ContractProjectPoc::GOVERNMENT_POC_TYPE)
    contract_project_data.add_contract_pocs(co_contract_poc_id, ContractProjectPoc::CONTRACT_OFFICE_POC_TYPE) 
  end

end

desc "Remove duplicate project users"
task :remove_duplicate_project_users => :environment do
  
  uniq_project_users = ProjectUser.all.group_by{|p| p.project_id}.transform_values{|pu| pu.map(&:user_id)}

  duplicate_records = []
  
  uniq_project_users.each do |project_id, user_ids|
    #t_values = user_ids.tally
    t_values = user_ids.group_by(&:itself).transform_values(&:count)
    t_values.each do |user_id,count|
      if count > 1
        duplicate_records << [project_id, user_id]
      end
    end
  end
  
  puts "**** Total duplicate records: #{duplicate_records.size} ****"
  
  duplicate_records.each do |project_id, user_id|
    if ProjectUser.where(project_id: project_id, user_id: user_id).count > 1
      pu = ProjectUser.where(project_id: project_id, user_id: user_id).last
      role_users = pu.user.role_users.where(project_id: project_id).map(&:dup)
      
      pu.destroy
      role_users.each do |role_user|
        role_user.dup.save
      end
    end
  end

end


desc "Update Facility Group"
task :update_facility_group_data => :environment do

  puts "Associating Facility Group to program"
  project_facility_group_hash = FacilityGroup.all.group_by{|fg| fg.project_id}
  project_facility_group_hash.each do |project_id, groups|
    next if project_id.nil?
    project = Project.find(project_id)
    project.project_group_ids = (project.project_group_ids + groups.map(&:id)).compact.uniq
  end
end

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

# desc "Modify User privileges for array"
# task :modify_user_privileges => :environment do

#   puts "Modifying data type for privileges"
#   users = User.all
#   users.each do |user|
#     privilege = user.privilege
#     next if !privilege
#     h = privilege.attributes
#     update_att = {}
#     h.each do |k,v|
#       next if ["user_id", "created_at", "updated_at", "id"].include?(k) || privilege.send(k).is_a?(Array)
#       o = []
#       o << "R" if privilege.send(k).include?("R")
#       o << "W" if privilege.send(k).include?("W")
#       o << "D" if privilege.send(k).include?("D")
#       update_att[k] = o
#     end
#     privilege.update(update_att)
#   end
# end

desc "Add Program privileges for User"
task :create_program_privileges => :environment do

  # Privilege.all.each do |privilege|
  #   privilege_attr = privilege.attributes.except("id", "created_at", "updated_at", "user_id", "project_id", "group_number").clone
  #   c = false
  #   privilege_attr.each do |k,v|
  #     if v.is_a?(String)
  #       privilege_attr[k] = v.chars
  #       c = true
  #     end
  #   end
  #   privilege.update(privilege_attr) if c
  # end

  puts "Adding Project privileges for User"
  User.includes([:projects, :project_privileges, :privilege]).all.each do |user|
    next if !user.project_ids.any?
    privilege = user.privilege
    privilege_attr = privilege.attributes.except("id", "created_at", "updated_at", "user_id", "project_id", "group_number", "portfolio_view", "facility_manager_view","map_view", "gantt_view", "watch_view", "documents", "members", "sheets_view", "kanban_view", "calendar_view" ).clone
    privilege_attr.each do |k,v|
      if v.is_a?(String)
        privilege_attr[k] = v.chars
      end
    end
    user_project_privileges = user.project_privileges
    project_to_create_privileges = []
    user.project_ids.each do |pid|
      p = user_project_privileges.detect{|p1| p1.project_ids.map(&:to_i).include?(pid) }
      if !p
        project_to_create_privileges << pid
      end
    end
    if project_to_create_privileges.any?
      privilege_attr.merge!(user_id: user.id, project_ids: project_to_create_privileges.map(&:to_s))
      p = ProjectPrivilege.create(privilege_attr)
    end
  end
end

desc 'Removes schema_migration entries for removed migration files'
task 'db:migrate:cleanup' => :environment do
  migration_context = ActiveRecord::Base.connection.migration_context
  versions_to_delete =migration_context.migrations_status.map { |_status, version, name| version if name.include?('NO FILE') }.compact.uniq

  migration_context.schema_migration.delete_by(version: versions_to_delete)

  puts "Cleaned up #{versions_to_delete.size} orphaned migrations."
end

desc "Reverting back to string in Privilege table"
task :revert_privileges => :environment do
  puts "Reverting back to string in Privilege table"
  Privilege.all.each do |p|
    if p.lessons.include?("\n") ||  p.lessons.include?("]")
      p.lessons = YAML.load(p.lessons).join("")
    end
    if p.calendar_view.include?("\n") ||  p.calendar_view.include?("]")
      p.calendar_view = YAML.load(p.calendar_view).join("")
    end
    if p.risks.include?("\n") ||  p.risks.include?("]")
      p.risks = YAML.load(p.risks).join("")
    end
    if p.kanban_view.include?("\n") ||  p.kanban_view.include?("]")
      p.kanban_view = YAML.load(p.kanban_view).join("")
    end
    if p.sheets_view.include?("\n") ||  p.sheets_view.include?("]")
      p.sheets_view = YAML.load(p.sheets_view).join("")
    end
    if p.facility_manager_view.include?("\n") ||  p.facility_manager_view.include?("]")
      p.facility_manager_view = YAML.load(p.facility_manager_view).join("")
    end
    if p.overview.include?("\n") ||  p.overview.include?("]")
      p.overview = YAML.load(p.overview).join("")
    end
    if p.tasks.include?("\n") ||  p.tasks.include?("]")
      p.tasks = YAML.load(p.tasks).join("")
    end
    if p.notes.include?("\n") ||  p.notes.include?("]")
      p.notes = YAML.load(p.notes).join("")
    end
    if p.issues.include?("\n") ||  p.issues.include?("]")
      p.issues = YAML.load(p.issues).join("")
    end
    if p.admin.include?("\n") ||  p.admin.include?("]")
      p.admin = YAML.load(p.admin).join("")
    end
    if p.map_view.include?("\n") ||  p.map_view.include?("]")
      p.map_view = YAML.load(p.map_view).join("")
    end
    if p.gantt_view.include?("\n") ||  p.gantt_view.include?("]")
      p.gantt_view = YAML.load(p.gantt_view).join("")
    end
    if p.watch_view.include?("\n") ||  p.watch_view.include?("]")
      p.watch_view = YAML.load(p.watch_view).join("")
    end
    if p.documents.include?("\n") ||  p.documents.include?("]")
      p.documents = YAML.load(p.documents).join("")
    end
    if p.members.include?("\n") ||  p.members.include?("]")
      p.members = YAML.load(p.members).join("")
    end
    p.save
  end
end

desc 'Grant all privileges of Lesson to all users'
task :grant_lesson_privileges => :environment do
  puts 'Granting all privileges of Lesson to all users'
  Privilege.update_all(lessons: "RWD")
end

desc 'Set sheet view as default privilege if no other is selected'
task :assign_default_privilege => :environment do
  puts 'Set sheet view as default privilege if no other is selected'
  Privilege.all.map(&:save)
end