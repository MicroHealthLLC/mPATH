client = User.find_or_initialize_by(email: 'client@test.com')
ContractPrivilege.create({
  "overview"=>[],
  "tasks"=>["R", "W", "D"],
  "notes"=>[],
  "issues"=>["R", "W", "D"],
  "admin"=>[],
  "risks"=>["R", "W", "D"],
  "lessons"=>["R", "W", "D"],
  "user_id"=>client.id,
  "contract_ids"=>client.contract_ids.map(&:to_s)
 })