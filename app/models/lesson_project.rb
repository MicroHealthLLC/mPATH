class LessonProject < ApplicationRecord
  belongs_to :lesson
  belongs_to :facility_project
end
