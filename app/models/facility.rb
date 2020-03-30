class Facility < ApplicationRecord
  belongs_to :facility_group
  belongs_to :creator, class_name: "User"
  belongs_to :status, optional: true
  has_many :facility_projects, dependent: :destroy
  has_many :projects, through: :facility_projects
  has_many :tasks, dependent: :destroy
  has_many :notes, as: :noteable
  has_many :comments, as: :resource, dependent: :destroy, class_name: 'ActiveAdmin::Comment'
  accepts_nested_attributes_for :comments, reject_if: :reject_comment

  validates_presence_of :facility_name, :address, :point_of_contact, :phone_number, :email

  # geocoded_by :address, latitude: :lat, longitude: :lng
  # after_validation :geocode, if: lambda { |f| f.address_changed? }

  def as_json(options=nil)
    json = super(options)
    json.merge(
      creator: self.creator.as_json,
      tasks: self.tasks.map(&:to_json),
      notes: self.notes.map(&:to_json),
      status: self.status.try(:name),
      progress: progress
    ).as_json
  end

  def progress
    self.tasks.map(&:progress).sum / self.tasks.count rescue 0
  end

  def reject_comment(comment)
    return comment['body'].blank?
  end
end
