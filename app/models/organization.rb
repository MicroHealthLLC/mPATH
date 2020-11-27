class Organization < ApplicationRecord
  has_many :users, dependent: :nullify
end
