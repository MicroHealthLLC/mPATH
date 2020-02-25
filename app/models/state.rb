class State < ApplicationRecord
  has_many :region_states, dependent: :destroy
  has_many :regions, through: :region_states
end
