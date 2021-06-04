class LessonsController < AuthenticatedController

  def index
    # authorize!(:read, Lesson.new(project_id: params[:program_id]))
    if params[:program_id] && params[:project_id]
      facility_project = FacilityProject.where(project_id: params[:program_id], facility_id: params[:project_id]).first
      if facility_project
        lessons = Lesson.where(facility_project_id: facility_project.id).includes([{lesson_files_attachments: :blob}, {lesson_users: [:user] }, :users, :notes, :lesson_details, :task_type ])
        response_hash = {lessons: lessons.map(&:to_json)}
        status_code = 200
      else
        response_hash = {errors: "Program or Project not found"}
        status_code = 404
      end
    else
      response_hash = {errors: "Program or Project not found"}
      status_code = 404
    end

    render json: response_hash, status: status_code
  end

  def create
    # authorize!(:create, Lesson.new)
    lesson = Lesson.new.create_or_update_lesson(params, current_user)
    render json: {lesson: lesson}, status: 200

  end

  def update
    lesson = Lesson.find(params[:lesson_id])
    # authorize!(:create, lesson)
    lesson.create_or_update_lesson(params, current_user)
    render json: {lesson: lesson.to_json}, status: 200
  end


  def show
    lesson = Lesson.find(params[:lesson_id])
    # authorize!(:read, lesson)
    
    render json: {lesson: lesson.to_json}, status: 200
  end

  def destroy
    lesson = Lesson.find(params[:lesson_id])
    # authorize!(:destroy, lesson)
    if lesson.destroy
      render json: {lesson: lesson}, status: 200
    else
      render json: {lesson: lesson}, status: 402
    end
  end

  private

  def lesson_params
    params.require(:lesson).permit(:title, :description, :date, :stage, :task_type_id, :task_id, :risk_id, :issue_id, :issue_type_id, :user_id, :project_id )
  end

end
