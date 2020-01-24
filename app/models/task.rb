class Task < ApplicationRecord
  belongs_to :project
  enum task_type: [:upgrade, :story]

  def as_json(options=nil)
    json = super(options)
    json.merge(
      progress: progress
    ).as_json
  end

  def progress
    60
  end
end
