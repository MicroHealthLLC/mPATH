class ProgressList < ApplicationRecord
  belongs_to :checklist
  belongs_to :user

  validates :text, :user_id, :checklist_id, presence: true

end
