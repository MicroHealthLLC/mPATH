class Facility < ApplicationRecord
  belongs_to :region
  belongs_to :creator, class_name: "User"
  belongs_to :project
  has_many :tasks, dependent: :destroy
  enum status: [:pending, :completed]

  # geocoded_by :address, latitude: :lat, longitude: :lng
  # after_validation :geocode, if: lambda { |f| f.address_changed? }

  def as_json(options=nil)
    json = super(options)
    json.merge(
      creator: self.creator.as_json,
      tasks: self.tasks.order(:due_date).map(&:as_json),
      progress: progress
    ).as_json
  end

  def progress
    self.tasks.map(&:progress).sum / self.tasks.count rescue 0
  end
end
