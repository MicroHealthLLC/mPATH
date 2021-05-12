FactoryBot.define do
  factory :user do
    email {"admin@test.com"}
    password {"T3$tAdmin"}
    password_confirmation {"T3$tAdmin"}
    first_name  {"Admin"}
    last_name  {"Test"}
    title {"Manager"}
    phone_number {"+447400123440"}
    address {"38 Wiltshire Rd, Leicester LE4 0JT, UK"}
    status {"active"}
    role {"superadmin"}
    organization {nil}

    before(:create) do |user|
      user.privilege { Privilege.build(overview {"RWD"}, tasks {"RWD"}, notes {"RWD"}, issues {"RWD"}, admin {"RWD"},
                                        map_view {"RWD"}, gantt_view {"RWD"}, watch_view {"RWD"}, documents {"RWD"},
                                        members {"RWD"}, facility_manager_view {"R"}, sheets_view {"R"}, kanban_view {"R"},
                                        risks {"R"}) }
    end

    trait :client do
      role  {"client"}
    end
  end
end
