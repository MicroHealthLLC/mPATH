class LandingController < AuthenticatedController
  def index
    # there is no need of eager loading here..
    @preferences = current_user.get_preferences
    @active_projects = current_user.authorized_programs.includes([:facilities, :users, :tasks, :issues, :risks, :facility_projects ])
  end
end
