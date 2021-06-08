class LessonDetail < ApplicationRecord
  # Detail Type: [success, failure, best_practices]
  DETAIL_TYPES = {
    0 => "success",
    1 => "failure",
    2 => "best_practices"
  }
  belongs_to :lesson
  def to_json
    self.as_json
  end

end
