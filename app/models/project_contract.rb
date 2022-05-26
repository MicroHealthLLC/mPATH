class ProjectContract < ApplicationRecord
  belongs_to :contract_project_datum
  belongs_to :project
  validates :project_id, uniqueness: { scope: [ :contract_project_datum_id ], message: "Can't add same contract multiple times in same project."  }
end
