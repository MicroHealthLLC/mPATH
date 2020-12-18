class ProjectTaskStage < ApplicationRecord
  belongs_to :project
  belongs_to :task_stage
end
