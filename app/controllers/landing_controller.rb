class LandingController < AuthenticatedController
  def index
    # there is no need of eager loading here..
    @preferences = current_user.get_preferences
    # @active_projects = current_user.projects.includes([:facilities, :users, :tasks, :issues, :risks, :facility_projects ]).active
    @active_projects = current_user.authorized_programs
  end
end
