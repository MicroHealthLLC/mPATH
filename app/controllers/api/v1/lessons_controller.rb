class Api::V1::LessonsController < AuthenticatedController 
# NOTE: uncomment this when we move to token based authentication
# class Api::V1::LessonsController < Api::ApplicationController
  before_action :authorize_request!, only: [:index, :count, :show]

  def authorize_request!
    if params[:contract_id]
      raise(CanCan::AccessDenied) if !current_user.has_contract_permission?(resource: 'lessons', contract: params[:contract_id])
    else
      raise CanCan::AccessDenied unless current_user.has_permission?(resource: 'lessons', program: params[:project_id], project: params[:facility_id], project_privileges_hash: nil, facility_privileges_hash: nil)
    end

  end

  def count
    pph = current_user.project_privileges_hash
    fph = current_user.facility_privileges_hash
    cph = current_user.contract_privileges_hash

    response_hash =  {total_count: 0, progress: 0, completed: 0 }
    status_code = 200
    
    if params[:project_id] && params[:facility_id] && fph[params[:project_id]] && fph[params[:project_id]][params[:facility_id]] && fph[params[:project_id]][params[:facility_id]]["lessons"].present?
      
      facility_project = FacilityProject.where(project_id: params[:project_id], facility_id: params[:facility_id]).first
      if facility_project
        lessons_count = Lesson.where(facility_project_id: facility_project.id).count
        progress = Lesson.where(facility_project_id: facility_project.id, draft: true).count
        completed = lessons_count - progress
        response_hash =  {total_count: lessons_count, progress: progress, completed: completed }
        status_code = 200
      else
        raise ActiveRecord::RecordNotFound
      end
    elsif params[:project_id]
      allowed_facility_ids = fph[params[:project_id]].map{|k,v| k if v["lessons"].present? }.compact
      allowed_contract_ids = cph[params[:project_id]].map{|k,v| k if v.is_a?(Hash) && v["lessons"].present? }.compact

      fp_ids = FacilityProject.where(project_id: params[:project_id], facility_id: allowed_facility_ids).pluck(:id)
      lesson_ids = []

      if allowed_contract_ids.any?
        lesson_ids += Lesson.where(contract_id: allowed_contract_ids).pluck(:id)
      end
      if fp_ids.any?
        lesson_ids += Lesson.where(facility_project_id: fp_ids).pluck(:id)
      end
      if lesson_ids.any?
        lessons_count = Lesson.where(id: lesson_ids).count
        progress = Lesson.where(id: lesson_ids, draft: true).count

        # lessons_count = Lesson.joins(:facility_project).where("facility_project.project_id" => params[:project_id]).count
        # progress = Lesson.joins(:facility_project).where("facility_project.project_id" => params[:project_id], draft: true).count
        completed = lessons_count - progress

        response_hash =  {total_count: lessons_count, progress: progress, completed: completed }
        status_code = 200
      end
    else
      raise ActionController::BadRequest 
    end
    render json: response_hash, status: status_code
  end

  def index

    fph = current_user.facility_privileges_hash
    cph = current_user.contract_privileges_hash
    
    # authorize!(:read, Lesson.new(project_id: params[:project_id]))    
    if params[:project_id] && params[:facility_id] && fph[params[:project_id]] && fph[params[:project_id]][params[:facility_id]] && fph[params[:project_id]][params[:facility_id]]["lessons"].present?
      # facility_project = FacilityProject.where(project_id: params[:project_id], facility_id: params[:facility_id]).first
      facility_project = FacilityProject.where(project_id: params[:project_id], facility_id: params[:facility_id]).first
      
      if facility_project
        lessons = Lesson.where(facility_project_id: facility_project.id).includes(Lesson.lesson_preload_array)
        response_hash = {lessons: lessons.map(&:build_response_for_index)}
        status_code = 200
      else
        response_hash = {errors: "Program or Project not found"}
        status_code = 404
      end
    elsif params[:project_id]
      allowed_facility_ids = fph[params[:project_id]].map{|k,v| k if v["lessons"].present? }.compact
      allowed_contract_ids = cph[params[:project_id]].map{|k,v| k if v.is_a?(Hash) && v["lessons"].present? }.compact

      fp_ids = FacilityProject.where(project_id: params[:project_id], facility_id: allowed_facility_ids).pluck(:id)
      response_lessons = []
      lesson_ids = []

      if fp_ids.any?
        lesson_ids = Lesson.joins(:facility_project).includes(Lesson.lesson_preload_array).where(facility_project_id: fp_ids).pluck(:id)
      end
      
      if allowed_contract_ids.any?
        lesson_ids += Lesson.where(contract_id: allowed_contract_ids).pluck(:id)
      end

      lessons = Lesson.includes(Lesson.lesson_preload_array).where(id: lesson_ids.compact.uniq).order(:id)
      response_lessons = lessons.map(&:build_response_for_index)

      response_hash = {lessons: response_lessons}
      status_code = 200

    elsif params[:contract_id]
      lessons = Lesson.where(contract_id: params[:contract_id]).includes(Lesson.lesson_preload_array)
      response_hash = {lessons: lessons.map(&:build_response_for_index)}
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
    params.require(:lesson).permit(:title, :description, :date, :stage, :task_type_id, :task_id, :risk_id, :issue_id, :issue_type_id, :user_id, :project_id )
  end

end
