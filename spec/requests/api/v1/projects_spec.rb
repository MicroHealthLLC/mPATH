require 'rails_helper'

RSpec.describe "Api::V1::Projects", type: :request do
  describe "GET api/v1/programs/:id" do
    it "works! (now write some real specs)" do
      binding.pry
      user = create(:user)
      program_admin_role = Role.program_admin_user_role 
      project = create(:project, admin_program_admins: [user.id.to_s])

      program_admin_role.role_users.create(user_id: user.id, project_id: project.id)
      
      get api_v1_projects_path(project.id)
      expect(response).to have_http_status(200)
    end
  end
end
