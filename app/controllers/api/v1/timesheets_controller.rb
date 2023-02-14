class Api::V1::TimesheetsController < AuthenticatedController 

  def index

    all_timesheets = Timesheet.includes([ :user, {facility_project: :facility} ]).where("timesheets.facility_project_id = ? && timesheets.user_id = ?", params[:facility_project_id], params[:user_id]).paginate(:page => params[:page], :per_page => 15)

    render json: {timesheets: all_timesheets, total_pages: all_timesheets.total_pages, current_page: all_timesheets.current_page, next_page: all_timesheets.next_page }
  end

  def create
    @timesheet = Timesheet.new.create_or_update_timesheet(params, current_user)

    if @timesheet.errors.any?
      render json: {timesheet: @timesheet, errors: @timesheet.errors.full_messages.join(", ") }, status: :unprocessable_entity
    else
      render json: {timesheet: @timesheet}
    end
  end

  def update
  end

  def destroy
  end
end
