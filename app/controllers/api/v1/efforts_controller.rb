class Api::V1::EffortsController < AuthenticatedController 
  before_action :set_resources#, except: [:show]
  before_action :set_effort, only: [:update, :destroy]
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

    all_efforts = Effort.includes([ :user, {facility_project: :facility} ]).where("efforts.facility_project_id = ? and timesheets.hours > 0", @owner.id)#.paginate(:page => params[:page], :per_page => 15)

    all_users = User.where(id: all_efforts.map(&:user_id))
    all_tasks = Task.where(facility_project_id: @owner.id)

    # total_pages = all_efforts.total_pages
    # current_page = all_efforts.current_page
    # next_page = all_efforts.next_page

    response = []
    all_efforts.group_by{|t| t.user}.each do |user, efforts|

      task_efforts = efforts.group_by(&:resource_id)
      h = []
      all_tasks.each do |task|
        efforts = task_efforts[task.id] || []
        h << task.as_json.merge!({efforts: efforts.map(&:to_json), actual_effort: efforts.sum(&:hours) }) 

      end
      response <<  user.as_json.merge!({tasks: h})
    end

    # render json: {efforts: response, total_pages: total_pages, current_page: current_page, next_page: next_page }
    render json: {efforts: response }
  end

  def create
    @effort = Effort.new.create_or_update_effort(params, current_user)

    if @effort.errors.any?
      render json: {errors: @effort.errors.full_messages.join(", ") }, status: :unprocessable_entity
    else
      render json: {effort: @effort}
    end
  end

  def update
    @effort.create_or_update_effort(params, current_user)
    @effort.reload
    if @effort.errors.any?
      render json: {effort: @effort, errors: @effort.errors.full_messages.join(", ") }, status: :unprocessable_entity
    else
      render json: {effort: @effort}
    end
  end

  def destroy
    @effort.destroy!
    render json: {effort: @effort}, status: 200
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

  def set_effort
    @effort = @owner.efforts.find(params[:id])
  end

  def effort_params
    params.require(:effort).permit(Effort.params_to_permit)
  end

end