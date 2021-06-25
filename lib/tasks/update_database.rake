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