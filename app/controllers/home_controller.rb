class HomeController < AuthenticatedController
  layout "application"
  layout "portfolio_viewer", only: [:portfolio, :contracts]
  
  def contracts
    if !current_user.can_access_contract_data?
      raise CanCan::AccessDenied
    end
    respond_to do |format|
      format.json {}
      format.html {render action: :portfolio}
    end
  end

  def settings
    @program_id = params[:all].split("/")[1]
    if !current_user.is_program_admin?(@program_id.to_i)
      raise CanCan::AccessDenied      
    end
    respond_to do |format|
      format.json {}
      format.html {render action: :index}
    end
  end

  def dataviewer
    @program_id = params[:all].split("/")[1]
    if !current_user.authorized_programs.pluck(:id).include?(@program_id.to_i)
      raise CanCan::AccessDenied      
    end
    
    respond_to do |format|
      format.json {}
      format.html {render action: :index}
    end
  end

  def profile
  end
  
  def landing
    # there is no need of eager loading here..
    @preferences = current_user.get_preferences
    @active_projects = current_user.authorized_programs.includes([:facilities, :users, :tasks, :issues, :risks, :lessons, :facility_projects ])
  end

  def index

    # tabs = ["map", "sheet", "calendar", "kanban","gantt_chart", "gantt","members","lessons"]
    # "/programs/:program_id/:tab/projects/:project_id/analytics"
    # Findnig tab from params
    params_split = params[:path].split("/")
    tab = params_split[2] || "map"
    @program_id = params_split[1]

    view = "map_view"
    if tab == "map"
      view = "map_view"
    elsif tab == "sheet"
      view = "sheets_view"
    elsif tab == "calendar"
      view = "calendar_view"
    elsif tab == "kanban"
      view = "kanban_view"
    elsif ["gantt_chart", "gantt"].include?(tab)
      view = "gantt_view"
    elsif tab == "members"
      view = "members"
    elsif tab == "lessons" || params[:lesson_id]
      view = "lessons"
    ##  elsif params[:tab] == "watch_view"
    ##    view = "watch_view"
    ##  elsif params[:tab] == "facility_manager"
    ##    view = "facility_manager_view" 
    else
      redirect_to current_user.allowed_redirect_url(@program_id)
      return
    end
    if current_user.authorized_programs.pluck(:id).include?(@program_id.to_i)
      if !current_user.allowed?(view)
        # raise CanCan::AccessDenied
        redirect_to current_user.allowed_redirect_url(@program_id)
        return
      end
    else
      raise CanCan::AccessDenied
    end
    
    respond_to do |format|
      format.json {}
      format.html {render action: :index}
    end
  end

  def portfolio
    if !current_user.authorized_programs.any?
      redirect_to root_path
    end
  end

end