class Lesson < ApplicationRecord
  belongs_to :user
  belongs_to :task_type, optional: true

  belongs_to :lesson_stage, optional: true
    
  has_many :lesson_users, dependent: :destroy
  has_many :users, through: :lesson_users
  
  belongs_to :facility_project

  has_many :notes, as: :noteable, dependent: :destroy
  has_many_attached :lesson_files, dependent: :destroy

  has_many :lesson_details, dependent: :destroy

  has_many :related_tasks, as: :relatable, dependent: :destroy
  has_many :related_issues, as: :relatable, dependent: :destroy
  has_many :related_risks, as: :relatable, dependent: :destroy
  has_many :sub_tasks, through: :related_tasks
  has_many :sub_issues, through: :related_issues
  has_many :sub_risks, through: :related_risks

  validates :title, :description, :date, :facility_project_id, presence: true
  accepts_nested_attributes_for :notes, reject_if: :all_blank, allow_destroy: true

  def to_json(options = {})
    attach_files = []
    tf = self.lesson_files
    if tf.attached?
      attach_files = tf.map do |file|
        next if !file.blob.filename.instance_variable_get("@filename").present?
        begin
          if file.blob.content_type == "text/plain" && valid_url?(file.blob.filename.instance_variable_get("@filename"))
            {
              id: file.id,
              name: file.blob.filename.instance_variable_get("@filename"),
              uri: file.blob.filename.instance_variable_get("@filename"),
              link: true
            }
          else
            {
              id: file.id,
              name: file.blob.filename,
              uri: Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true),
              link: false
            }
          end
        rescue Exception => e
          puts "There is an exception"
        end
      end.compact.uniq
    end
    
    t_users = options[:all_task_users] || []
    all_users = options[:all_users] || []
    if options[:for].present? && [:project_build_response, :lesson_index].include?(options[:for])
      resource_users = t_users
    else
      resource_users = self.lesson_users #.where(user_id: self.users.active.uniq.map(&:id) )
    end
    
    p_users = []

    if all_users.any?
      p_users = all_users.select{|u| resource_user_ids.include?(u.id) }
    else
      p_users = users.select(&:active?)
    end

    users_hash = {} 
    p_users.map{|u| users_hash[u.id] = {id: u.id, name: u.full_name} }

    # Last name values added for improved sorting in datatables
    users_last_name_hash = {} 
    p_users.map{|u| users_last_name_hash[u.id] = u.last_name }

    # First name values added for improved sorting in datatables
    users_first_name_hash = {} 
    p_users.map{|u| users_first_name_hash[u.id] = u.first_name }
    self.as_json.merge(
      class_name: self.class.name,
      attach_files: attach_files,
      user_ids: p_users.map(&:id).compact.uniq,
      user_names: p_users.map(&:full_name).compact.join(", "),
      users: p_users.as_json(only: [:id, :full_name, :title, :phone_number, :first_name, :last_name, :email]),
      lesson_details: self.lesson_details.map(&:to_json),
      lesson_stage_id: self.lesson_stage_id,
      notes: notes.as_json,
      notes_updated_at: notes.map(&:updated_at).compact.uniq,
      project_id: facility_project.facility_id,
      sub_tasks: sub_tasks.as_json(only: [:text, :id]),
      sub_issues: sub_issues.as_json(only: [:title, :id]),
      sub_task_ids: sub_tasks.map(&:id),
      sub_issue_ids: sub_issues.map(&:id),
      sub_risk_ids: sub_risks.map(&:id)
    ).as_json
  end

  def create_or_update_lesson(params, user)

    lesson_params = params.require(:lesson).permit(
      :title, 
      :description, 
      :date, 
      :stage, 
      :task_type_id,  
      :facility_project_id,
      :user_id, 
      # :project_id,
      :lesson_stage_id,
      sub_task_ids: [],
      sub_issue_ids: [],
      sub_risk_ids: [],
      lesson_files: [],
      user_ids: [],
      # facility_project_ids: [],
      notes_attributes: [
        :id,
        :_destroy,
        :user_id,
        :body
      ],
      lesson_details: [
        :id,
        :_destroy,
        :user_id,
        :finding,
        :recommendation,
        :detail_type
      ]
    )

    lesson = self
    lesson.user_id = user.id
    t_params = lesson_params.dup
    sub_task_ids = t_params.delete(:sub_task_ids)
    sub_issue_ids = t_params.delete(:sub_issue_ids)
    sub_risk_ids = t_params.delete(:sub_risk_ids)
    notes_attributes = t_params.delete(:notes_attributes)
    params_lesson_details = t_params.delete(:lesson_details)

    if params[:project_id] && params[:facility_id]
      fp = FacilityProject.where(project_id: params[:project_id], facility_id: params[:facility_id]).first
      t_params[:facility_project_id] = fp.id
    end

    lesson.attributes = t_params
    lesson.date ||= Date.today
     
    lesson.transaction do
      lesson.save
      lesson.add_link_attachment(params)

      if notes_attributes.present?
        existing_notes = self.notes
        notes_objs = []
        notes_attributes.each do |key, value|
          if value[:_destroy].present?
            n = existing_notes.detect{|e| e.id.to_s == value["id"]}.destroy
            n.destroy if n
          elsif value[:id].present?
            n = existing_notes.detect{|e| e.id.to_s == value["id"]}
            n.update(value) if n
          else
            notes_objs << Note.new(value.merge({noteable_id: lesson.id, noteable_type: "Lesson"}) )
          end
        end
        Note.import(notes_objs) if notes_objs.any?
      end

      if params_lesson_details.present?
        existing_lesson_details = self.lesson_details
        lesson_detail_objs = []
        params_lesson_details.each do |key, value|
          if value[:_destroy].present?
            l = existing_lesson_details.detect{|e| e.id.to_s == value["id"]}.destroy
            l.destroy if l
          elsif value[:id].present?
            l = existing_lesson_details.detect{|e| e.id.to_s == value["id"]}
            l.update(value) if l
          else
            lesson_detail_objs << LessonDetail.new(value.merge({lesson_id: lesson.id}) )
          end
        end
        LessonDetail.import(lesson_detail_objs) if lesson_detail_objs.any?
      end

      if sub_task_ids && sub_task_ids.any?
        related_task_objs = []
        related_task_objs2 = []
        sub_task_ids.each do |sid|
          related_task_objs << RelatedTask.new(relatable_id: lesson.id, relatable_type: "Lesson", task_id: sid)
          
          # NOTE: As we are not going to show the related Lesson in Task, we don't need to create RelatedLesson

          # related_task_objs2 << RelatedTask.new(relatable_id: sid, relatable_type: "Task", task_id: task.id)
        end
        RelatedTask.import(related_task_objs) if related_task_objs.any?
        RelatedTask.import(related_task_objs2) if related_task_objs2.any?
      end

      if sub_issue_ids && sub_issue_ids.any?
        related_issue_objs = []
        related_issue_objs2 = []
        sub_issue_ids.each do |sid|
          related_issue_objs << RelatedIssue.new(relatable_id: lesson.id, relatable_type: "Lesson", issue_id: sid)
          # related_issue_objs2 << RelatedTask.new(relatable_id: sid, relatable_type: "Issue", task_id: task.id)
        end
        RelatedIssue.import(related_issue_objs) if related_issue_objs.any?
        RelatedTask.import(related_issue_objs2) if related_issue_objs2.any?
      end
      
      if sub_risk_ids && sub_risk_ids.any?
        related_risk_objs = []
        related_risk_objs2 = []
        sub_risk_ids.each do |sid|
          related_risk_objs << RelatedRisk.new(relatable_id: lesson.id, relatable_type: "Lesson", risk_id: sid)
          # related_risk_objs2 << RelatedTask.new(relatable_id: sid, relatable_type: "Risk", task_id: task.id)
        end
        RelatedRisk.import(related_risk_objs) if related_risk_objs.any?
        RelatedTask.import(related_risk_objs2) if related_risk_objs2.any?
      end

    end
    lesson.persisted?  ? lesson.reload : lesson
  end

  def valid_url?(url)
    uri = URI.parse(url)
    (uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS) ) && !uri.host.nil?
  rescue URI::InvalidURIError
    false
  end

  def add_link_attachment(params = {})
    link_files = params[:file_links]
    if link_files && link_files.any?
      link_files.each do |f|
        next if !f.present? || f.nil? || !valid_url?(f)
        self.lesson_files.attach(io: StringIO.new(f), filename: f, content_type: "text/plain")
      end
    end
  end


  # def assign_users(params)
  #   resource_users = []

  #   resource = self

  #   user_ids = resource.user_ids

  #   users_to_delete = []

  #   if params[:user_ids].present?
  #     params[:user_ids].each do |uid|
  #       next if uid == "undefined"
  #       if !user_ids.include?(uid.to_i)
  #         user_ids << uid
  #         # resource_users << LessonUser.new(user_id: uid, lesson_id: resource.id)
  #       end
  #     end
  #   end
    
  #   records_to_import = accountable_resource_users + responsible_resource_users + consulted_resource_users + informed_resource_users
    
  #   if users_to_delete.any?
  #     resource_users.where(user_id: users_to_delete).destroy_all
  #   end

  #   if records_to_import.any?
  #     LessonUser.import(records_to_import)
  #   end
  # end

end
