class LessonsController < AuthenticatedController

  def index
    # authorize!(:read, Lesson.new(project_id: params[:program_id]))
    project = Project.find(params[:program_id])
    lessons = project.lessons.where(facility_project_id: params[:project_id]).includes([{lesson_files_attachments: :blob}, {lesson_users: [:user] }, {lesson_projects: [{facility_project: :facility}] }, :users, :facilities, :facility_projects, :notes, :lesson_details, :task, :risk, :issue, :task_type, :issue_type, :project ])
    render json: {lessons: lessons.map(&:to_json)}, status: 200
  end

  def create
    # authorize!(:create, Lesson.new)
    lesson = Lesson.new.create_or_update_lession(params, current_user)
    render json: {lesson: lesson}, status: 200

  end

  def update
    lesson = Lesson.find(params[:id])
    # authorize!(:create, lesson)
    lesson.create_or_update_lession(params, current_user)
    render json: {lesson: lesson.to_json}, status: 200
  end


  def show
    lesson = Lesson.find(params[:id])
    # authorize!(:read, lesson)
    
    render json: {lesson: lesson.to_json}, status: 200
  end

  def destroy
    lesson = Lesson.find(params[:id])
    # authorize!(:destroy, lesson)
    if lesson.destroy
      render json: {lesson: lesson}, status: 200
    else
      render json: {lesson: lesson}, status: 402
    end
  end

  private

  def lession_params
    params.require(:lesson).permit(:title, :description, :date, :stage, :task_type_id, :task_id, :risk_id, :issue_id, :issue_type_id, :user_id, :project_id )
  end

end
