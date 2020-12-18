class LandingController < AuthenticatedController
  def index
    # there is no need of eager loading here..
    @active_projects = current_user.projects.active
  end
end
