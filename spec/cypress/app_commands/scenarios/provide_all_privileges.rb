client = User.find_or_initialize_by(email: 'client@test.com')
client.project_ids.each do |project_id|
  RoleUser.new(project_id: project_id, user_id: client.id, role_id: Role.program_admin_user_role.id ).save
end
update_project_role =  Role.where(name: "update-project").first

facility_projects = client.facility_projects
facility_projects.each do |facility_project|
  RoleUser.new(project_id: facility_project.project_id, facility_project_id: facility_project.id, user_id: client.id, role_id: update_project_role.id, user_id: client.id ).save
end

# ProjectPrivilege.create({
#  "overview"=>[],
#  "tasks"=>["R", "W", "D"],
#  "notes"=>[],
#  "issues"=>["R", "W", "D"],
#  "admin"=>[],
#  "risks"=>["R", "W", "D"],
#  "lessons"=>["R", "W", "D"],
#  "contracts"=>["R", "W", "D"],
#  "user_id"=>client.id,
#  "project_ids"=>client.project_ids.map(&:to_s) })

#  client.project_ids.each do |pid|
#   ContractPrivilege.create({
#     "overview"=>[],
#     "tasks"=>["R", "W", "D"],
#     "notes"=>[],
#     "issues"=>["R", "W", "D"],
#     "admin"=>[],
#     "risks"=>["R", "W", "D"],
#     "lessons"=>["R", "W", "D"],
#     "user_id"=>client.id,
#     "project_id" => pid,
#     "contract_ids"=>client.contract_ids.map(&:to_s)
#   })
# end
