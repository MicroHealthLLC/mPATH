class State < ApplicationRecord
  has_many :region_states, dependent: :destroy
  has_many :facility_group, through: :region_states
end
