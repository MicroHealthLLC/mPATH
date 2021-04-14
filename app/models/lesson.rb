class Lesson < ApplicationRecord
  belongs_to :user
  belongs_to :task, optional: true
  belongs_to :risk, optional: true
  belongs_to :issue, optional: true
  belongs_to :task_type, optional: true
  belongs_to :issue_type, optional: true

  has_many :lesson_users, dependent: :destroy
  has_many :users, through: :lesson_users
  has_many :notes, as: :noteable, dependent: :destroy
  has_many_attached :task_files, dependent: :destroy

  validates :title, :description, :date, presence: true
  accepts_nested_attributes_for :notes, reject_if: :all_blank, allow_destroy: true


end
