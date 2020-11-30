class LandingController < AuthenticatedController
  def index
  	@active_projects = current_user.projects.includes(:facilities, facility_projects: :tasks).active
  end
end
