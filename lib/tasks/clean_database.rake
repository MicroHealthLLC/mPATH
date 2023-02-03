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

end