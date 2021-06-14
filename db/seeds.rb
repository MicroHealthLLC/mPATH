
puts "Seed the application..."

user = User.find_or_initialize_by(email: 'admin3@example.com') do |user|  
  user.password = 'adminPa$$w0rd'
  user.password_confirmation = 'adminPa$$w0rd'
  user.title = 'Mr.'
  user.first_name =  'Super'
  user.role = "superadmin"
  user.last_name =  'Admin'
end

if user.privilege.nil?
  # user.privilege = Privilege.new(lessons: "RWD", overview: "RWD", tasks: "RWD", notes: "RWD", issues: "RWD", admin: "RWD", map_view: "RWD", gantt_view: "RWD", watch_view: "RWD", documents: "RWD", members: "RWD")
  user.privilege = Privilege.new(lessons: ["R"],calendar_view: ["R"], risks: ["R"],kanban_view: ["R"],sheets_view: ["R"], facility_manager_view: ["R"], overview: ["R", "W", "D"], tasks: ["R", "W", "D"], notes: ["R", "W", "D"], issues: ["R", "W", "D"], admin: ["R", "W", "D"], map_view: ["R", "W", "D"], gantt_view: ["R", "W", "D"], watch_view: ["R", "W", "D"], documents: ["R", "W", "D"], members: ["R", "W", "D"])
end

user.save(validate: false)

puts "superuser created with email: #{user.email}"

FacilityGroup.find_or_create_by(name: 'Sample Group', code: 'SAMP', status: 'active')
Setting.first_or_create(google_map_key: ENV['GOOGLE_MAP_KEY'])

puts "Seeds completed.."

Status.find_or_create_by(name: "Not Started", color: "#000000")