class FacilityGroup < SortableRecord
  default_scope {order(FacilityGroup.order_humanize)}
  has_many :facilities
  has_many :facility_projects, through: :facilities

  validates :name, presence: true, uniqueness: true

  enum status: [:inactive, :active].freeze

  def as_json(options=nil)
    json = super(options)
    json.merge(
      facilities: self.facility_projects.as_json,
      facility_count: self.facilities.count,
      project_ids: self.facility_projects.pluck(:project_id).uniq
    ).as_json
  end

  def progress
    self.facility_projects.map(&:progress).sum / self.facility_projects.count rescue 0
  end

  def destroy
    raise ActiveRecord::StatementInvalid.new "asasas" if facilities.present?
  end
end
