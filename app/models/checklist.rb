class Checklist < ApplicationRecord
  default_scope {order(created_at: :asc)}
  belongs_to :listable, polymorphic: true
  belongs_to :user, optional: true
end
