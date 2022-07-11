require 'rails_helper'

RSpec.describe "Api::V1::Projects", type: :request do
  describe "GET api/v1/programs/:id" do
    it "works! (now write some real specs)" do
      project = FactoryBot.create(:project)
      get api_v1_projects_path(project.id)
      expect(response).to have_http_status(200)
    end
  end
end
