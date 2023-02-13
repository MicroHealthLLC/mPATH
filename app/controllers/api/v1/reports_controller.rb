class Api::V1::ReportsController < AuthenticatedController


  def user_progress_report
    user = User.find(params[:user_id])

    tasks = Task.includes(:task_users).where("task_users.user_id = ?", user.id)

    projects = FacilityProject.where(id: tasks.pluck(:facility_project_id).uniq)

    report_data = []

    projects.each do |project|
      h = project.attributes
      h[:tasks] = project.tasks.map(&:to_json)
      report_data << h
    end
    
    render json: {data: report_data}, status: 200
  end

end