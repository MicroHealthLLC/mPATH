FactoryBot.define do
  factory :project do
    name    { Faker::Internet.email }
    description { Faker::Internet.password }
  end
end