class LessonsController < AuthenticatedController

  def index
    project = Project.find(params[:project_id])
    render json: {lessons: project.lessons.map(&:to_json)}, status: 200
  end

  def create
    lesson = Lesson.new.create_or_update_lession(params, current_user)
    render json: {lesson: lesson}, status: 200

  end

  def update
    lesson = Lesson.find(params[:id]).create_or_update_lession(params, current_user)
    render json: {lesson: lesson}, status: 200
  end


  def show
    lesson = Lesson.find(params[:id])
    render json: {lesson: lesson}, status: 200
  end

  def destroy
    lesson = Lesson.find(params[:id])
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
