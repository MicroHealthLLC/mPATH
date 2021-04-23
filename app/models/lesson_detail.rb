class LessonDetail < ApplicationRecord
  # Detail Type: [success, failure, best_practices]
  belongs_to :lesson
  def to_json
    self.as_json
  end

end
