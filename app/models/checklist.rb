class Checklist < ApplicationRecord
  include Normalizer
  include CommonUtilities

  default_scope {order(position: :asc)}
  belongs_to :listable, polymorphic: true
  belongs_to :user, optional: true
  has_many :progress_lists, dependent: :destroy
  accepts_nested_attributes_for :progress_lists, reject_if: :all_blank, allow_destroy: true
  
  after_save :calculate_planned_effort

  def calculate_planned_effort
    listable.calculate_planned_effort
  end

  def as_json(options=nil)
    json = super(options)
    json.merge(
      # user: self.user.as_json(only: [:id, :full_name]),
      planned_effort: strip_trailing_zero(self.planned_effort),
      user: self.user&.checklist_json,
      progress_lists: ( self.progress_lists )
    ).as_json
  end
end
