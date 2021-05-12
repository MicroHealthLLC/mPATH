require 'rails_helper'

RSpec.describe LandingController, type: :controller do

  login_user

  describe "GET #index" do
    it "returns a success response" do
      get :index

      expect(response).to be_successful # be_successful expects a HTTP Status code of 200
    end
  end
end
