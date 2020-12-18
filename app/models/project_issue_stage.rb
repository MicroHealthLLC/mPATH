class ProjectIssueStage < ApplicationRecord
  belongs_to :project
  belongs_to :issue_stage
end
