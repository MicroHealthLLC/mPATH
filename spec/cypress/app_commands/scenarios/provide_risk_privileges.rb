client = User.find_or_initialize_by(email: 'client@test.com')
ProjectPrivilege.create({
 "overview"=>["R", "W", "D"],
 "tasks"=>["R", "W", "D"],
 "notes"=>["R", "W", "D"],
 "issues"=>["R", "W", "D"],
 "admin"=>["R", "W", "D"],
 "risks"=>["R", "W", "D"],
 "lessons"=>["R", "W", "D"],
 "user_id"=>client.id,
 "project_ids"=>client.project_ids.map(&:to_s) })