# Earlier we had is_default attribute to project_facility_group table
# but since default group will be one per program, we have added field to facility_groups table
class FacilityGroup < SortableRecord
  # default_scope {order(FacilityGroup.order_humanize)}
  has_many :facilities
  has_many :facility_projects
  has_many :project_contracts
  has_many :project_contract_vehicles
  has_many :project_facility_groups
  has_many :projects, through: :project_facility_groups
  has_many :contracts

  validates :name, presence: true #, uniqueness: true
  scope :portfolio, -> {where(is_portfolio: true)}
  enum status: [:inactive, :active].freeze
  before_save :set_status

  def set_status
    if !status
      status = :active
    end
  end

  def as_json(options=nil)
    json = super(options)
  end

  def update_progress
    t = self.facility_projects
    p = 0
    if t.any?
      p = (t.map(&:progress).sum / t.size).round(0)
    end
    self.update(progress: p)
  end

  def destroy
    if is_default || is_portfolio
      (raise ActiveRecord::StatementInvalid.new("Can't destroy because Groups is either default or portoflio group.") )
    else
      super
    end
  end
end
