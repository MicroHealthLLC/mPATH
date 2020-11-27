class Checklist < ApplicationRecord
  include Normalizer

  default_scope {order(created_at: :asc)}
  belongs_to :listable, polymorphic: true
  belongs_to :user, optional: true

  def as_json(options=nil)
    json = super(options)
    json.merge(
      user: self.user.as_json(only: [:id, :full_name]),
    ).as_json
  end
end
