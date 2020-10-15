class RelatedTask < ApplicationRecord
  belongs_to :relatable, polymorphic: true
  belongs_to :sub_task, class_name: "Task", foreign_key: 'task_id'
end
