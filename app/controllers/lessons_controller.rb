class LessonsController < AuthenticatedController

  def count 

    if params[:program_id] && params[:project_id]
      facility_project = FacilityProject.where(project_id: params[:program_id], facility_id: params[:project_id]).first
      if facility_project
        lessons_count = Lesson.where(facility_project_id: facility_project.id).count
        progress = Lesson.where(facility_project_id: facility_project.id, draft: true).count
        completed = lessons_count - progress
        response_hash =  {total_count: lessons_count, progress: progress, completed: completed }
        status_code = 200
      else
        raise ActiveRecord::RecordNotFound
      end
    elsif params[:program_id]
      lessons_count = Lesson.joins(:facility_project).where("facility_project.project_id" => params[:program_id]).count
      progress = Lesson.joins(:facility_project).where("facility_project.project_id" => params[:program_id], draft: true).count
      completed = lessons_count - progress

      response_hash =  {total_count: lessons_count, progress: progress, completed: completed }
      status_code = 200
    else
      raise ActionController::BadRequest 
    end
    render json: response_hash, status: status_code
  end

  def index
    # authorize!(:read, Lesson.new(project_id: params[:program_id]))
    if params[:program_id] && params[:project_id]
      facility_project = FacilityProject.where(project_id: params[:program_id], facility_id: params[:project_id]).first
      if facility_project
        lessons = Lesson.where(facility_project_id: facility_project.id).includes(Lesson.lesson_preload_array)
        response_hash = {lessons: lessons.map(&:build_response_for_index)}
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
    if lesson.errors.any?
      render json: {errors: lesson.errors.full_messages.join(" ")}, status: 402
    else
      render json: {lesson: lesson.to_json}, status: 200
    end
  end

  def update
    lesson = Lesson.includes(Lesson.lesson_preload_array).find(params[:lesson_id])
    # authorize!(:create, lesson)

    lesson = lesson.create_or_update_lesson(params, current_user)

    if lesson.errors.any?
      render json: {errors: lesson.errors.full_messages.join(" ")}, status: 402
    else
      render json: {lesson: lesson.to_json}, status: 200
    end
  end


  def show
    lesson = Lesson.includes(Lesson.lesson_preload_array).find(params[:lesson_id])
    # authorize!(:read, lesson)
    
    render json: {lesson: lesson.to_json}, status: 200
  end

  def destroy
    lesson = Lesson.find(params[:lesson_id])
    # authorize!(:destroy, lesson)
    if lesson.destroy
      render json: {lesson: lesson.to_json}, status: 200
    else
      render json: {lesson: lesson.to_json}, status: 402
    end
  end

  private

  def lesson_params
    params.require(:lesson).permit(:title, :description, :date, :stage, :task_type_id, :task_id, :risk_id, :issue_id, :issue_type_id, :user_id, :project_id )
  end

end
