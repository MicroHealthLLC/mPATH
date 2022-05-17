class ProjectContract < ApplicationRecord
  belongs_to :contract
  belongs_to :project
  validates :project_id, uniqueness: { scope: [ :contract_id ], message: "Can't add same contract multiple times in same project."  }
end
