class LessonDetail < ApplicationRecord
  # Detail Type: [success, failure, best_practices]
  belongs_to :lesson
  belongs_to :user
  validates_presence_of :user_id, :detail_type, :lesson_id, :finding

  def success?
    detail_type == "success"
  end

  def failure?
    detail_type == "failure"
  end

  def best_practices?
    detail_type == "best_practices"
  end

  def to_json
    #self.as_json
    {
      id: id,
      finding: finding,
      recommendation: recommendation,
      detail_type: detail_type,
      user_id: user_id,
      updated_at: updated_at
    }
  end

end
