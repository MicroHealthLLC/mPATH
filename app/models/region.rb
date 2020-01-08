class Region < ApplicationRecord
  has_many :facilities
  validates :name, uniqueness: true
  enum status: [:inactive, :active]
  enum region_type: ["ugly", "country", "state"].freeze
  before_save do
    self.center ||= '[]'
    self.boundary ||= '[]'
  end
end
