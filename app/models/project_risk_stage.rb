class ProjectRiskStage < ApplicationRecord
  belongs_to :project
  belongs_to :risk_stage
end
