# RoleUser.new(project_id: project.id, facility_project_id: facility_project_1.id, user_id: client.id, role_id: project_update_role.id ).save
client = User.where(email: 'client@test.com').first
RoleUser.where(user_id: client.id).destroy_all

read_role = Role.where(name: "read-project").first
client.facility_projects.each do |facility_project|
  RoleUser.new(project_id: facility_project.project_id, facility_project_id: facility_project.id,user_id: client.id, role_id: read_role.id ).save
end
