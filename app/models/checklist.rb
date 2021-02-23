class Checklist < ApplicationRecord
  include Normalizer

  default_scope {order(position: :asc)}
  belongs_to :listable, polymorphic: true
  belongs_to :user, optional: true
  has_many :progress_lists, dependent: :destroy
  accepts_nested_attributes_for :progress_lists, reject_if: :all_blank, allow_destroy: true

  def as_json(options=nil)
    json = super(options)
    json.merge(
      user: self.user.as_json(only: [:id, :full_name]),
      progress_lists: ( self.progress_lists )
    ).as_json
  end
end
