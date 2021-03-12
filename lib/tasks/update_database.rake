desc "Update Facility Project"
task :update_facility_project_progress => :environment do

  puts "Updating Facility Project"
  FacilityProject.all.map(&:update_progress)
  FacilityProject.all.map(&:update_color)
end