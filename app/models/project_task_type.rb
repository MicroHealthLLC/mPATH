class ProjectTaskType < ApplicationRecord
  belongs_to :project
  belongs_to :task_type
end
