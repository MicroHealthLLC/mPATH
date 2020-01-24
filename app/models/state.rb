class State < ApplicationRecord
  belongs_to :region, optional: true
end
