class LessonsController < AuthenticatedController

  def index
    render json: {lessons: Lesson.all}, status: 200
  end

  def create
    
  end

  def update

  end


  def show
    
  end

  private

  def check_permit(view)
    return unless current_user.allowed?(view)
  end
end
