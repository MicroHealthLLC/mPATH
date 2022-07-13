FactoryBot.define do
  factory :project do
    name    { Faker::Internet.email }
    description { Faker::Internet.password }
    project_type_id { create(:project_type).id }
    users {[create(:user)]}
  end
  
  factory :project_type do
    name    { Faker::Internet.name }
  end

  factory :user do
    first_name    { Faker::Name.first_name }
    last_name    { Faker::Name.last_name }
    email {Faker::Internet.email}
    password {Faker::Internet.password}
    password_confirmation {password}
  end



end