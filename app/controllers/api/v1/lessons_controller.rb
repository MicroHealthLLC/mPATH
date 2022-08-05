class Api::V1::LessonsController < AuthenticatedController 
# NOTE: uncomment this when we move to token based authentication
# class Api::V1::LessonsController < Api::ApplicationController
  before_action :check_permission, only: [:show]

  def check_permission
    action = nil
    if ["index", "show" ].include?(params[:action]) 
      action = "read"
    elsif ["create", "update", "create_duplicate", "create_bulk_duplicate", "batch_update"].include?(params[:action]) 
      action = "write"
    elsif ["destroy"].include?(params[:action]) 
      action = "delete"
    end

    if params[:project_contract_id]
      raise(CanCan::AccessDenied) if !current_user.has_contract_permission?(action: action,resource: 'lessons', project_contract: params[:project_contract_id])
    elsif params[:project_contract_vehicle_id]
      raise(CanCan::AccessDenied) if !current_user.has_contract_permission?(action: action,resource: 'risks', project_contract_vehicle: params[:project_contract_vehicle_id])
    else
      raise(CanCan::AccessDenied) if !current_user.has_permission?(action: action,resource: 'lessons', program: params[:project_id], project: params[:facility_id])
    end
  end

  def count

    response_hash =  {total_count: 0, progress: 0, completed: 0 }
    status_code = 200
    authorized_program_ids = current_user.authorized_program_ids
    project_id = params[:project_id]

    raise(CanCan::AccessDenied) if !project_id || !authorized_program_ids.include?(project_id.to_i)

    authorized_facility_project_ids = current_user.authorized_facility_project_ids(project_ids: [project_id])
    authorized_project_contract_ids = current_user.authorized_contract_ids(project_ids: [project_id])

    if project_id && authorized_program_ids.include?(project_id.to_i)

      fp_ids = FacilityProject.where(project_id: project_id, id: authorized_facility_project_ids).pluck(:id)
      lesson_ids = []
      c_lesson_ids = []

      if authorized_project_contract_ids.any?
        c_lesson_ids = Lesson.where(project_contract_id: authorized_project_contract_ids).pluck(:id)
      end
      if fp_ids.any?
        lesson_ids += Lesson.where(facility_project_id: fp_ids).pluck(:id)
      end
      if lesson_ids.any?
        lessons_count = Lesson.where(id: lesson_ids).count
        c_lessons_count = Lesson.where(id: c_lesson_ids).count
        progress = Lesson.where(id: lesson_ids, draft: true).count
        c_lessons_progress = Lesson.where(id: c_lesson_ids, draft: true).count

        completed = lessons_count - progress
        c_lessons_completed = c_lessons_count - c_lessons_progress

        response_hash =  {total_count: lessons_count, progress: progress, completed: completed, total_contract_lessons: c_lessons_count }
        status_code = 200
      end

    elsif project_id && params[:facility_id]
      
      facility_project = FacilityProject.where(project_id: project_id, facility_id: params[:facility_id]).first
      if facility_project
        lessons_count = Lesson.where(facility_project_id: facility_project.id).count
        progress = Lesson.where(facility_project_id: facility_project.id, draft: true).count
        completed = lessons_count - progress
        response_hash =  {total_count: lessons_count, progress: progress, completed: completed }
        status_code = 200
      else
        raise ActiveRecord::RecordNotFound
      end

    elsif project_id && params[:facility_id]
      
      facility_project = FacilityProject.where(project_id: project_id, facility_id: params[:facility_id]).first
      if facility_project
        lessons_count = Lesson.where(facility_project_id: facility_project.id).count
        progress = Lesson.where(facility_project_id: facility_project.id, draft: true).count
        completed = lessons_count - progress
        response_hash =  {total_count: lessons_count, progress: progress, completed: completed }
        status_code = 200
      else
        raise ActiveRecord::RecordNotFound
      end

    else
      raise ActionController::BadRequest 
    end
    render json: response_hash, status: status_code
  end

  def index
    
    role_users = current_user.role_users
    project_id = params[:project_id].to_i
    lessons = []
    response_hash = {lessons: []}
    if params[:project_id] && params[:facility_id]

      raise(CanCan::AccessDenied)  if !current_user.has_permission?(resource: 'lessons', program: params[:project_id], project: params[:facility_id])
      
      facility_project = FacilityProject.where(project_id: params[:project_id], facility_id: params[:facility_id]).first
            
      if facility_project
        lessons = Lesson.where(facility_project_id: facility_project.id).includes(Lesson.lesson_preload_array)
        response_hash = {lessons: lessons.map(&:build_response_for_index)}
        status_code = 200
      else
        response_hash = {lessons: lessons, errors: "Program or Project not found"}
        status_code = 200
      end
    elsif params[:project_contract_id]
      allowed_project_contract_ids = current_user.authorized_contract_ids(project_ids: [params[:project_id]])
      if allowed_project_contract_ids.include?(params[:project_contract_id].to_i)
        lessons = Lesson.where(project_contract_id: params[:project_contract_id]).includes(Lesson.lesson_preload_array)
        response_hash = {lessons: lessons.map(&:build_response_for_index)}
        status_code = 200
      end
    elsif params[:project_contract_vehicle_id]
      allowed_project_contract_vehicle_ids = current_user.authorized_contract_vehicle_ids(project_ids: [params[:project_id]])
      if allowed_project_contract_ids.include?(params[:project_contract_vehicle_id].to_i)
        lessons = Lesson.where(project_contract_vehicle_id: params[:project_contract_vehicle_id]).includes(Lesson.lesson_preload_array)
        response_hash = {lessons: lessons.map(&:build_response_for_index)}
        status_code = 200
      end
    elsif project_id

      authorized_facility_project_ids = current_user.authorized_facility_project_ids(project_ids: [project_id])
      authorized_project_contract_ids = current_user.authorized_contract_ids(project_ids: [project_id])
  
      response_lessons = []
      lesson_ids = []

      if authorized_facility_project_ids.any?
        lesson_ids = Lesson.joins(:facility_project).includes(Lesson.lesson_preload_array).where(facility_project_id: authorized_facility_project_ids).distinct.pluck(:id)
      end
      
      if authorized_project_contract_ids.any?
        lesson_ids += Lesson.where(project_contract_id: authorized_project_contract_ids).distinct.pluck(:id)
      end

      lessons = Lesson.includes(Lesson.lesson_preload_array).where(id: lesson_ids.compact.uniq).order(:id)
      response_lessons = lessons.map(&:build_response_for_index)

      response_hash = {lessons: response_lessons}
      status_code = 200

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
      render json: {errors: lesson.errors.full_messages.join(" ")}, status: 406
    else
      render json: {lesson: lesson.to_json}, status: 200
    end
  end

  def update
    lesson = Lesson.includes(Lesson.lesson_preload_array).find(params[:id])
    # authorize!(:create, lesson)

    lesson = lesson.create_or_update_lesson(params, current_user)

    if lesson.errors.any?
      render json: {errors: lesson.errors.full_messages.join(" ")}, status: 402
    else
      render json: {lesson: lesson.to_json}, status: 200
    end
  end


  def show
    lesson = Lesson.includes(Lesson.lesson_preload_array).find(params[:id])
    # authorize!(:read, lesson)
    
    render json: {lesson: lesson.to_json}, status: 200
  end

  def destroy
    lesson = Lesson.find(params[:id])
    # authorize!(:destroy, lesson)
    if lesson.destroy
      render json: {lesson: lesson.to_json}, status: 200
    else
      render json: {lesson: lesson.to_json}, status: 402
    end
  end

  private

  def lesson_params
    params.require(:lesson).permit(:title, :description, :date, :stage, :task_type_id, :task_id, :risk_id, :issue_id, :issue_type_id, :user_id, :project_id, :project_contract_id )
  end

end
