
puts "Seed the application..."

user = User.find_or_initialize_by(email: 'admin@example.com') do |user|  
  user.password = 'adminPa$$w0rd'
  user.password_confirmation = 'adminPa$$w0rd'
  user.title = 'Mr.'
  user.first_name =  'Super'
  user.role = "superadmin"
  user.last_name =  'Admin'
end

if user.privilege.nil?
  user.privilege = Privilege.new(overview: "RWD", tasks: "RWD", notes: "RWD", issues: "RWD", admin: "RWD", map_view: "RWD", gantt_view: "RWD", watch_view: "RWD", documents: "RWD", members: "RWD")
end

user.save(validate: false)

puts "superuser created with email: #{user.email}"

FacilityGroup.find_or_create_by(name: 'Sample Group', code: 'SAMP', status: 'active')
Setting.first_or_create(google_map_key: ENV['GOOGLE_MAP_KEY'])

puts "Seeds completed.."

Status.find_or_create_by(name: "Not Started", color: "#000000")