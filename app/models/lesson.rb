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
  has_many_attached :task_files, dependent: :destroy

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
    end
    lesson.reload
  end

end
