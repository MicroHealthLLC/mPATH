desc "Clean Database"
task :clean_database => :environment do
  puts "Cleaning FacilityProject with missing FacilityGroup"
  
  facility_group_ids = FacilityGroup.ids
  invalid_facility_project_ids = []
  FacilityProject.in_batches do |fps|
    fps.includes(:facility_group).each do |f|
      if !facility_group_ids.include?(f.facility_group_id)
        invalid_facility_project_ids << f.id
        f.assign_default_facility_group
      end
    end  
  end 
  puts "Total FacilityProject with invalid facility group: #{invalid_facility_project_ids.size}"

  puts "Cleaning Role User data"  
  puts "Total RoleUser cleared: #{RoleUser.remove_bad_records.size}"

  puts "Cleaning FacilityProject with missing Project"
  
  project_ids = Project.ids
  invalid_facility_project_ids = []
  FacilityProject.in_batches do |fps|
    fps.includes(:project).each do |f|
      if !project_ids.include?(f.project_id)
        invalid_facility_project_ids << f.id
        f.destroy
      end
    end  
  end 
  puts "Total FacilityProject with missing project: #{invalid_facility_project_ids.size}"


end