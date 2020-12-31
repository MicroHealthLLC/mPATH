class RiskUser < ApplicationRecord
  belongs_to :user
  belongs_to :risk
end
