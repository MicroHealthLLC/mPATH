class LandingController < AuthenticatedController
  def index
    # there is no need of eager loading here..
    @preferences = current_user.get_preferences
    @active_projects = current_user.projects.active.includes([:facilities, facility_projects: [:tasks, :status , :facility ]])
  end
end
