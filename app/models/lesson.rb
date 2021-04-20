class Lesson < ApplicationRecord
  belongs_to :user
  belongs_to :task, optional: true
  belongs_to :risk, optional: true
  belongs_to :issue, optional: true
  belongs_to :task_type, optional: true
  belongs_to :issue_type, optional: true

  has_many :lesson_users, dependent: :destroy
  has_many :users, through: :lesson_users
  has_many :notes, as: :noteable, dependent: :destroy
  has_many_attached :lesson_files, dependent: :destroy

  validates :title, :description, :date, presence: true
  accepts_nested_attributes_for :notes, reject_if: :all_blank, allow_destroy: true

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
      ]
    )

    lesson = self
    t_params = lesson_params.dup
    notes_attributes = t_params.delete(:notes_attributes)

    lesson.attributes = t_params

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

    end
    lesson.reload
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
