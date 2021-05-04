class ProjectLessonStage < ApplicationRecord
  belongs_to :project
  belongs_to :lesson_stage
end
