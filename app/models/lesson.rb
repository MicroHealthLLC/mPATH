class Lesson < ApplicationRecord
  belongs_to :user
  belongs_to :task, optional: true
  belongs_to :risk, optional: true
  belongs_to :issue, optional: true
  belongs_to :task_type, optional: true
  belongs_to :issue_type, optional: true
  belongs_to :project
  
  has_many :lesson_users, dependent: :destroy
  has_many :users, through: :lesson_users
  has_many :notes, as: :noteable, dependent: :destroy
  has_many_attached :lesson_files, dependent: :destroy

  has_many :lesson_details, dependent: :destroy

  validates :title, :description, presence: true
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
    fp = self.project

    t_users = options[:all_task_users] || []
    all_users = options[:all_users] || []
    if options[:for].present? && [:project_build_response, :task_index].include?(options[:for])
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
      notes: notes.as_json,
      notes_updated_at: notes.map(&:updated_at).compact.uniq,

    ).as_json
  end

  def create_or_update_lession(params, user)

    lesson_params = params.require(:lesson).permit(
      :title, 
      :description, 
      :date, 
      :stage, 
      :task_type_id, 
      :task_id, 
      :risk_id, 
      :issue_id, 
      :issue_type_id, 
      :user_id, 
      :project_id,
      lesson_files: [],
      user_ids: [],
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
    notes_attributes = t_params.delete(:notes_attributes)
    params_lesson_details = t_params.delete(:lesson_details)

    lesson.attributes = t_params
    lesson.date ||= Date.today
     
    lesson.transaction do
      lesson.save
      lesson.add_link_attachment(params)

      if notes_attributes.present?
        notes_objs = []
        notes_attributes.each do |key, value|
          value.delete("_destroy")
          notes_objs << Note.new(value.merge({noteable_id: lesson.id, noteable_type: "Lesson"}) )
        end
        Note.import(notes_objs) if notes_objs.any?
      end

      if params_lesson_details.present?
        lesson_detail_objs = []
        params_lesson_details.each do |key, value|
          value.delete("_destroy")
          lesson_detail_objs << LessonDetail.new(value.merge({lesson_id: lesson.id}) )
        end
        LessonDetail.import(lesson_detail_objs) if lesson_detail_objs.any?
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
