class Api::V1::TimesheetsController < AuthenticatedController 
  before_action :set_resources#, except: [:show]
  before_action :set_timesheet, only: [:update, :destroy]
  # before_action :check_permission

  def check_permission
    action = nil
    if ["index", "show" ].include?(params[:action]) 
      action = "read"
    elsif ["create", "update"].include?(params[:action]) 
      action = "write"
    elsif ["destroy"].include?(params[:action]) 
      action = "delete"
    end

    if params[:project_contract_id]
      raise(CanCan::AccessDenied) if !current_user.has_contract_permission?(action: action,resource: 'tasks', project_contract: params[:project_contract_id])
    elsif params[:project_contract_vehicle_id]
      raise(CanCan::AccessDenied) if !current_user.has_contract_permission?(action: action,resource: 'tasks', project_contract_vehicle: params[:project_contract_vehicle_id])
    else
      raise(CanCan::AccessDenied) if !current_user.has_permission?(action: action,resource: 'tasks', program: params[:project_id], project: params[:facility_id])
    end
  end

  def index

    all_timesheets = Timesheet.includes([ :user, {facility_project: :facility} ]).where("timesheets.facility_project_id = ?", "timehseets.hours > 0", @owner.id)#.paginate(:page => params[:page], :per_page => 15)

    all_users = User.where(id: all_timesheets.map(&:user_id))
    all_tasks = Task.where(facility_project_id: @owner.id)

    # total_pages = all_timesheets.total_pages
    # current_page = all_timesheets.current_page
    # next_page = all_timesheets.next_page

    response = []
    all_timesheets.group_by{|t| t.user}.each do |user, timesheets|

      task_timesheets = timesheets.group_by(&:resource_id)
      h = []
      all_tasks.each do |task|
        timesheets = task_timesheets[task.id] || []
        h << task.as_json.merge!({timesheets: timesheets.map(&:to_json), actual_effort: timesheets.sum(&:hours) }) 

      end
      response <<  user.as_json.merge!({tasks: h})
    end

    # render json: {timesheets: response, total_pages: total_pages, current_page: current_page, next_page: next_page }
    render json: {timesheets: response }
  end

  def create
    @timesheet = Timesheet.new.create_or_update_timesheet(params, current_user)

    if @timesheet.errors.any?
      render json: {errors: @timesheet.errors.full_messages.join(", ") }, status: :unprocessable_entity
    else
      render json: {timesheet: @timesheet}
    end
  end

  def update
    @timesheet.create_or_update_timesheet(params, current_user)
    @timesheet.reload
    if @timesheet.errors.any?
      render json: {timesheet: @timesheet, errors: @timesheet.errors.full_messages.join(", ") }, status: :unprocessable_entity
    else
      render json: {timesheet: @timesheet}
    end
  end

  def destroy
    @timesheet.destroy!
    render json: {timesheet: @timesheet}, status: 200
  end

  private
  def set_resources
    @owner = nil
    if params[:project_contract_id]
      @owner = current_user.authorized_contracts.find_by(id: params[:project_contract_id] )
    elsif params[:project_contract_vehicle_id]
      @owner = ProjectContractVehicle.find_by(id: params[:project_contract_vehicle_id] )
    else
      @project = current_user.authorized_programs.find_by(id: params[:project_id])
      @owner = @project.facility_projects.find_by(facility_id: params[:facility_id])
    end
  end

  def set_timesheet
    @timesheet = @owner.timesheets.find(params[:id])
  end

  def timesheet_params
    params.require(:timesheet).permit(Timesheet.params_to_permit)
  end

end