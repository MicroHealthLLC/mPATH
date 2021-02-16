class ProgressList < ApplicationRecord
  belongs_to :checklist
  belongs_to :user, optional: true

  validates :body, presence: true

  def as_json(options=nil)
    json = super(options)
    json.merge(
      user: self.user.as_json(only: [:id, :full_name])
    ).as_json
  end

end
