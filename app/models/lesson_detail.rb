class LessonDetail < ApplicationRecord
  # Detail Type: [success, failure, best_practices]
  belongs_to :lesson
end
