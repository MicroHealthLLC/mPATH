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