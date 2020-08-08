# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# if Rails.env.development?
  User.create_with(
    password: 'password',
    password_confirmation: 'password',
    first_name: 'admin',
    role: "superadmin",
    last_name: 'admin'
  ).find_or_create_by(email: 'admin@example.com')

  @region = FacilityGroup.find_or_create_by(name: 'Sample Region', code: 'SAMP')
  states = [ ]
  states.each do |state|
    State.create_with(
      center: state["center"],
      region: @region
    ).find_or_create_by(
      name: state["name"], code: state["code"]
    )
    puts state["name"] + " created!\n"
  end

  setting = Setting.first_or_create(google_map_key: ENV['GOOGLE_MAP_KEY'])
# end
