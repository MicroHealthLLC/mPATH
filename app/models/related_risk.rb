class RelatedRisk < ApplicationRecord
  belongs_to :relatable, polymorphic: true
  belongs_to :sub_risk, class_name: "Risk", foreign_key: 'risk_id'
end
