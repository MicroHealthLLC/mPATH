class LandingController < AuthenticatedController
  def index
    # there is no need of eager loading here..
    @active_projects = current_user.projects.active.includes([:facilities, facility_projects: [:tasks, :status , :facility ]])
  end
end
