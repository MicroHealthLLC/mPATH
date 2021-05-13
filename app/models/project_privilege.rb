class ProjectPrivilege < ApplicationRecord
  belongs_to :user
  belongs_to :project

  serialize :overview, Array
  serialize :admin, Array
  serialize :tasks, Array
  serialize :issues, Array
  serialize :risks, Array
  serialize :notes, Array
end
